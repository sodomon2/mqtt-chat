#!/usr/bin/lua5.1
--[[--
 @package   Mqtt-chat
 @filename  src/init.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Diego Alejandro <sodomon2@gmail.com>
 @date      19.02.2021 02:51:18 -04
--]]

--- @See https://github.com/tacigar/lua-mqtt
--- @See https://github.com/craigmj/json4lua
mqtt  		= require('mqtt')
json  		= require('lib.json')

lgi   		= require('lgi')

GObject     = lgi.require('GObject', '2.0')
Gdk         = lgi.require('Gdk', '3.0')
GLib        = lgi.require('GLib', '2.0')
Gtk         = lgi.require('Gtk', '3.0')
Notify      = lgi.require('Notify')

builder     = Gtk.Builder()

builder:add_from_file('../data/chat.ui')
ui = builder.objects
msg = nil
Notify.init("Mqtt-chat")

-- Mqtt-Chat files
require 'app'
require 'tray'
require 'messages'

ui.login_window:show_all()
Gtk.main()