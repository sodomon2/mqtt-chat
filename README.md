# MQTT-Chat
A simple MQTT chat in lua

## Dependencies

- GTK+ 3.20+
- GLib 2.0+
- LibNotify
- GObject-Introspection
- [lua-mosquitto](https://github.com/flukso/lua-mosquitto)
- [lua-cjson](https://www.kyne.com.au/~mark/software/lua-cjson.php)
- [Lua5.1+](https://www.lua.org/download.html) (or [LuaJIT 2.0+](https://luajit.org/))
- [LGI](https://github.com/pavouk/lgi)

### Execute

```bash
$ git clone https://github.com/sodomon2/mqtt-chat.git
$ cd mqtt-chat && cd src/
$ lua5.1 init.lua (or luajit init.lua)
```