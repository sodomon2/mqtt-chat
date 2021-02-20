#!/usr/bin/lua5.1
--[[--
 @package   Mqtt-chat
 @filename  init.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Diego Alejandro <sodomon2@gmail.com>
 @date      19.02.2021 02:51:18 -04
--]]

--- @See https://github.com/tacigar/lua-mqtt
local mqtt  = require('mqtt')

local json  = require('lib.json')
local lgi   = require('lgi')

GObject     = lgi.require('GObject', '2.0')
Gdk         = lgi.require('Gdk', '3.0')
GLib        = lgi.require('GLib', '2.0')
Gtk         = lgi.require('Gtk', '3.0')
Notify      = lgi.require('Notify')

builder     = Gtk.Builder()

builder:add_from_file('data/chat.ui')
ui = builder.objects
msg = nil
Notify.init("Mqtt-chat")

-- Mqtt-Chat files
require 'src.tray'

function login()
	username    = ui.entry_user.text
	broker 	    = ui.entry_broker.text
	topic       = ui.entry_topic.text

	client      = mqtt.AsyncClient {
	  serverURI = broker,
	  clientID  = username,
	}

	client:setCallbacks(nil, function(topicName, message)
		msg = message.payload
	end, nil)
	client:connect{}
	client:subscribe(topic, 1)
end

function ui.btn_login:on_clicked()    
	login()
	ui.chat_icon.visible = true
	ui.login_window:hide()
	ui.main_window:show_all()
end

function send()
	local msje = tostring(ui.entry_message.text)
	if ( msje ~= '' ) then
		local info = {
			username = username,
			message = msje,
			time = os.date('%H:%M')
		}
		client:publish( topic, json.encode(info))
		ui.entry_message.text = ''
	end
end
ui.entry_message:grab_focus()

local mark = ui.buffer_messages:create_mark(nil, ui.buffer_messages:get_end_iter(), false)

GLib.timeout_add(
	GLib.PRIORITY_DEFAULT, 500,
	function()
		if msg then
			local message = json.decode(msg)
			print(message.username .. ': ' .. message.message)
			ui.buffer_messages:insert(ui.buffer_messages:get_iter_at_mark(mark),
				'\n'
				.. ('%s [%s]: %s'):format(message.time, message.username, message.message),
			-1)
			if ui.main_window.is_active == false then
				if message.username ~= username then
					notification = Notify.Notification.new(
						message.username,
						message.message,
						'avatar-default'
					)
					notification:show()
				end
			end
			ui.messages:scroll_mark_onscreen(mark)
			msg = nil
		end
		return true
	end
)

function quit()
	if ui.main_window.is_active == true then
		client:disconnect(1000)
		client:destroy()
		Gtk.main_quit()
	else
		Gtk.main_quit()
	end
end 

function ui.btn_send:on_clicked()
	send()
end

function ui.entry_message:on_key_release_event(env)
	if ( env.keyval  == Gdk.KEY_Return ) then
		send()
	end
end

function ui.main_window:on_destroy()
	quit()
end

function ui.btn_quit:on_clicked()
	quit()
end

function ui.login_window:on_destroy()
	quit()
end

function ui.menu_quit:on_clicked()
   quit()
end

function ui.menu_about:on_clicked()
	ui.about_window:run()
	ui.about_window:hide()
end

ui.login_window:show_all()
Gtk.main()