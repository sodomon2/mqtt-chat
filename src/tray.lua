--[[--
 @package   Mqtt-chat
 @filename  src/tray.lua
 @version   1.0
 @autor     Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      19.02.2021 03:17:20 -04
]]

ui.chat_icon.visible = false
function statusicon()
	visible = not visible
    if ( ui.login_window.is_active == true ) or ( ui.login_window.is_active == false ) then
		if ( visible ) then
			ui.main_window:show_all()
        else
            ui.main_window:hide()
        end
    end
end

function ui.chat_icon:on_activate()
	statusicon()
end

function create_menu(event_button, event_time)
	local menu = Gtk.Menu {
		Gtk.ImageMenuItem {
			label = "Show",
			image = Gtk.Image {
			  icon_name = "image-missing"
			},
			on_activate = function()
                ui.main_window:show_all()
			end
		},
		Gtk.ImageMenuItem {
			label = "Hide",
			image = Gtk.Image {
			  icon_name = "image-missing"
			},
			on_activate = function()
                ui.main_window:hide()
			end
		},
		Gtk.SeparatorMenuItem {},
		Gtk.ImageMenuItem {
			label = "Quit",
			image = Gtk.Image {
			  icon_name = "application-exit-symbolic"
			},
			on_activate = function()
				quit()
			end
		}
	}
	menu:show_all()
	menu:popup(nil, nil, nil, event_button, event_time)
end

function ui.chat_icon:on_popup_menu(ev, time)
	create_menu(ev, time)
end
