--[[--
 @package   Mqtt-chat
 @filename  src/messages.lua
 @version   1.0
 @autor     Diaz Urbaneja Victor Diego Alejandro <sodomon2@gmail.com>
 @date      22.02.2021 01:20:52 -04
]]

local styles = Gtk.CssProvider()
--- Thanks to diazvictor for css styles
styles:load_from_path('../data/styles/custom.css')

ui.main_window:get_style_context().add_provider_for_screen(
	ui.main_window:get_screen(window),
	styles,
	Gtk.STYLE_PROVIDER_PRIORITY_USER
)
ui.message_box:get_style_context():add_class('message-box')

function new_message(message_type, username, message, message_time)
	if message_type == 'for' then
		message = Gtk.ListBoxRow {
			visible = true,
			activatable = false,
			selectable = false,
			Gtk.Box {
				visible = true,
				can_focus = false,
				halign = Gtk.Align.END,
				orientation = Gtk.Orientation.VERTICAL,
				{
					Gtk.Box {
						id = 'message',
						visible = true,
						can_focus = false,
						halign = Gtk.Align.END,
						orientation = Gtk.Orientation.HORIZONTAL,
						Gtk.Label {
							visible = true,
							halign = Gtk.Align.END,
							label = message,
							use_markup = true,
							selectable = true
						}
					},
					expand = false,
					fill = true,
					position = 0
				},
				{
					Gtk.Label {
						id = 'time',
						visible = true,
						halign = Gtk.Align.END,
						label = message_time
					},
					expand = false,
					fill = true,
					position = 1
				},
			}
		}
		ui.message_box.on_size_allocate = function ()
			local adj = ui.scroll_box:get_vadjustment()
			adj:set_value(adj.upper - adj.page_size)
		end
		message:get_style_context():add_class('message-for')
	elseif message_type == 'from' then
		message = Gtk.ListBoxRow {
			visible = true,
			activatable = false,
			selectable = false,
			Gtk.Box {
				visible = true,
				can_focus = false,
				halign = Gtk.Align.START,
				orientation = Gtk.Orientation.VERTICAL,
				{
					Gtk.Label {
						id = 'author',
						visible = true,
						halign = Gtk.Align.START,
						label = username
					},
					expand = false,
					fill = true,
					position = 0
				},
				{
					Gtk.Box {
						visible = true,
						can_focus = false,
						orientation = Gtk.Orientation.HORIZONTAL,
						{
							Gtk.Image {
								id = 'avatar',
								visible = true,
								valign = Gtk.Align.END,
								icon_name = 'avatar-default-symbolic',
								icon_size = 5
							}
						},
						{
							Gtk.Box {
								id = 'message',
								visible = true,
								can_focus = false,
								orientation = Gtk.Orientation.HORIZONTAL,
								Gtk.Label {
									visible = true,
									label = message,
									use_markup = true,
									selectable = true
								}
							}
						}
					},
					expand = false,
					fill = true,
					position = 1
				},
				{
					Gtk.Label {
						id = 'time',
						visible = true,
						halign = Gtk.Align.END,
						label = message_time
					},
					expand = false,
					fill = true,
					position = 2
				},
			}
		}
		message:get_style_context():add_class('message-from')
		message.child.author:get_style_context():add_class('title')
		message.child.avatar:get_style_context():add_class('icon')
		message.child.avatar:get_style_context():add_class('avatar')
	end

	message.child.message:get_style_context():add_class('message')
	message.child.time:get_style_context():add_class('time')

	ui.message_box:add(message)
	return true
end

function send()
	local msje = tostring(ui.entry_message.text)
	if ( msje ~= '' ) then
		local info = {
			username = username,
			message = msje,
			time = os.date('%H:%M')
		}
		client:publish(topic, json.encode(info))
		ui.entry_message.text = ''
	end
end
ui.entry_message:grab_focus()

function ui.entry_message:on_key_release_event(env)
	if ( env.keyval == Gdk.KEY_Return ) then
		send()
	end
end

function ui.entry_topic:on_key_release_event(env)
	if ( env.keyval == Gdk.KEY_Return ) then
		login()
	end
end

GLib.timeout_add(
	GLib.PRIORITY_DEFAULT, 500,
	function()
		if msg then
			local message = json.decode(msg)
			print(message.username .. ': ' .. message.message)
			if message.username == username then
				new_message('for', nil, message.message, os.date('%H:%M'))
			end
			if message.username ~= username then
				new_message('from', message.username, message.message, os.date('%H:%M'))
				if ui.main_window.is_active == false then
					notification = Notify.Notification.new(
						message.username,
						message.message,
						'avatar-default-symbolic'
					)
					notification:show()
				end
			end
			msg = nil
		end
		return true
	end
)

function ui.btn_send:on_clicked()
	send()
end
