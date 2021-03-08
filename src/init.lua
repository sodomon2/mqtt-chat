#!/usr/bin/lua5.1
--[[--
 @package   Mqtt-chat
 @filename  src/init.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Diego Alejandro <sodomon2@gmail.com>
 @date      19.02.2021 02:51:18 -04
--]]

--- @See https://github.com/flukso/lua-mosquitto
--- @See https://www.kyne.com.au/~mark/software/lua-cjson.php
mqtt  		= require('mosquitto')
json  		= require('cjson.safe')
lgi   		= require('lgi')

GObject     = lgi.require('GObject', '2.0')
Gdk         = lgi.require('Gdk', '3.0')
GLib        = lgi.require('GLib', '2.0')
Gtk         = lgi.require('Gtk', '3.0')
Pango       = lgi.require('Pango', '1.0')
Notify      = lgi.require('Notify')

builder     = Gtk.Builder()

builder:add_from_file('../data/chat.ui')
ui  = builder.objects
msg = nil

Notify.init("Notifications-initialized")

-- Mqtt-Chat files
require 'messages'
require 'tray'
require 'app'

ui.login_window:show_all()
Gtk.main()