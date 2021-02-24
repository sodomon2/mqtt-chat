--[[--
 @package   Mqtt-chat
 @filename  src/app.lua
 @version   1.0
 @autor     Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      22.02.2021 00:11:52 -04
]]

function make_random()
	math.randomseed(os.time())
	return tostring(math.random(10000, 100000))
end

function connect()
	local user_id = make_random()
	client 	= mqtt.new( user_id .. '-mqtt_chat', false )
	
	client.ON_CONNECT = function ()
		client:subscribe(topic, 2)
		ui.notify_revealer:set_reveal_child(false)
	end
	
	client.ON_MESSAGE = function ( mid, topic, payload )
		local msg = json.decode(payload)
		
		if not msg then return end
		if ( msg.username == username ) then return end
		
		if ( msg.message and msg.username ) then
			message_log('from', msg.username, msg.message)
			new_message('from', msg.username, msg.message, os.date('%H:%M'))
			if ui.main_window.is_active == false then
				notification = Notify.Notification.new(
					msg.username,
					emoji.emojify(msg.message),
					'avatar-default-symbolic'
				)
				notification:show()
			end	
		end
		collectgarbage("collect")
	end

	client.ON_DISCONNECT = function ()
		local ok, errno, errmsg
		repeat
			ok, errno, errmsg = client:reconnect_async()
			if (not ok) then
				io.write('ERROR ',errno, errmsg, "\n")
			else
				io.write("REconnecting ..\n")
				ui.notify_revealer:set_reveal_child(true)
			end
		until(ok == true)
	end

	client:connect_async( broker, 1883, 60 )
	GLib.timeout_add(GLib.PRIORITY_DEFAULT, 300,function ()
			client:loop(1)
			return true
		end
	)
end

function ui.button_notify_close:on_clicked()
	ui.notify_revealer:set_reveal_child(false)
end

function login()
	local result = true
	username     = ui.entry_user.text
	broker 	     = ui.entry_broker.text
	topic        = ui.entry_topic.text


	if username == '' or broker == '' or topic == '' then
		ui.error:set_reveal_child(true)
		ui.msg_err.label = 'Please insert username, broker and topic'
		result = false
		return
	end


	if result then
		connect()
	end

	ui.chat_icon.visible = true
	ui.login_window:hide()
	ui.main_window:show_all()
end

function ui.btn_login:on_clicked()    
	login()
end

function quit()
	if ui.main_window.is_active == true then
		client:destroy()
		Gtk.main_quit()
	else
		Gtk.main_quit()
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
