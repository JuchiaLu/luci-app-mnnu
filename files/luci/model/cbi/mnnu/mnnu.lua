local FS = require "nixio.fs"
local UCI = require "luci.model.uci"
local m,section1,section2

function trim(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function cbi_add_networks(field)
	UCI.cursor():foreach("network", "interface",
		function (section)
			if section[".name"] ~= "loopback" then
				field:value(section[".name"])
			end
		end
	)
end

m = Map("mnnu", "闽南师大校园网叠加助手")

section1 = m:section(TypedSection, "global", "全局")
section1.anonymous=true --不显示section的名字

--第一节的第一个表
section1:tab("setting", "设置") -- setting 是 section 名
loglevel = section1:taboption("setting",ListValue, "loglevel", "日志级别","级别越高显示日志越少")
loglevel:value("1", "1调试")
loglevel:value("2", "2普通")
loglevel:value("3", "3警告")
loglevel:value("4", "4错误")
loglevel:value("5", "5致命")
loglevel.default = 2


--第一节的第二个表
section1:tab("mnnuLog", "运行日志") -- mnnuLog 是 section 名
mnnuLog=section1:taboption("mnnuLog",TextValue,"log")
mnnuLog.rows=20
mnnuLog.wrap="off" --禁止显示左右拖动条
mnnuLog.readonly=true
mnnuLog.cfgvalue=function(self, section) --重写读取配置方法
return FS.readfile("/var/log/mnnu.log")or"暂无日志"
end
mnnuLog.write=function(self, section, value) --重写写入配置方法
    --do nothing
end


--第二节
section2 = m:section(TypedSection, "user", "全部账户")
section2.addremove = true --添加, 删除按钮

username = section2:option(Value, "username", "学号")
function username.write (self, section, value)
    Value.write(self, section, trim(value))
end

password = section2:option(Value, "password", "密码")
password.password = true
function password.write (self, section, value)
    Value.write(self, section, trim(value))
end

interface = section2:option(ListValue, "interface", "设备名")
for k, v in ipairs(luci.sys.net.devices()) do
	interface:value(v)
end
function interface.write (self, section, value)
    Value.write(self, section, trim(value))
end


mwan3interface = section2:option(ListValue, "mwan3interface", "接口名")
cbi_add_networks(mwan3interface)
function mwan3interface.write (self, section, value)
    Value.write(self, section, trim(value))
end

lastmessage = section2:option(TextValue, "message", "消息")
lastmessage.size=60
lastmessage.readonly=true
lastmessage.write=function(self, section, value) --重写写入配置方法
    -- do nothing
end
lastmessage.cfgvalue=function(self, section)
 return UCI:get("mnnu",section,"message")or"未执行过任何操作!"
end

enable = section2:option(Flag, "enable", "启用")
enable.rmempty=false

return m