# MQTT-Chat
A simple MQTT chat in lua

## Dependencies

- GTK+ 3.20+
- GLib 2.0+
- LibNotify
- GObject-Introspection
- [lua-mosquitto](https://github.com/flukso/lua-mosquitt) with reconnect_async enabled. **for more information see this [commit](https://github.com/flukso/lua-mosquitto/tree/8f2696ed0db39665230d34cd29e2d6b46961e19c)**
- [Lua5.1+](https://www.lua.org/download.html) (or [LuaJIT 2.0+](https://luajit.org/))
- [LGI](https://github.com/pavouk/lgi)
- [emoji.lua](https://github.com/kitsunies/emoji.lua)

### Execute

```bash
$ git clone https://github.com/sodomon2/mqtt-chat.git
$ cd mqtt-chat && cd src/
$ lua5.1 init.lua (or luajit init.lua)
```