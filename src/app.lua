--[[--
 @package   Mqtt-chat
 @filename  src/app.lua
 @version   1.0
 @autor     Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      22.02.2021 00:11:52 -04
]]

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
	
	ui.chat_icon.visible = true
	ui.login_window:hide()
	ui.main_window:show_all()
end

function ui.btn_login:on_clicked()    
	login()
end

function quit()
	if ui.main_window.is_active == true then
		client:disconnect(1000)
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
