local m, s, o
local sys = require "luci.sys"
local util = require "luci.util"

m = Map("seu_net_login", translate("SEU 校园网认证"), translate("使用 curl 向认证服务器发送GET请求以实现校园网认证"))

s = m:section(TypedSection, "login", translate("登录设置"))
s.anonymous = true
s.addremove = false

o = s:option(Value, "username", translate("用户名"))
o.rmempty = false

o = s:option(Value, "password", translate("密码"))
o.password = true
o.rmempty = false

-- 添加网络接口选择
o = s:option(ListValue, "interface", translate("网络接口"))

-- 获取所有接口及其IP地址
local interfaces = {}
for _, iface in ipairs(sys.net.devices()) do
    if iface:match("^wlan%d") or iface:match("^eth%d") then
        local ip = util.trim(sys.exec("ip addr show " .. iface .. " | grep 'inet ' | awk '{print $2}' | cut -d/ -f1"))
        if ip ~= "" then
            interfaces[iface] = iface .. " (" .. ip .. ")"
            o:value(iface, interfaces[iface])
        end
    end
end

o.rmempty = false

o = s:option(Button, "_login", translate("登录"))
o.inputstyle = "apply"
o.write = function(self, section)
    local uci = require "luci.model.uci".cursor()
    
    -- 保存表单数据到配置文件
    uci:set("seu_net_login", section, "username", self.map:get(section, "username"))
    uci:set("seu_net_login", section, "password", self.map:get(section, "password"))
    uci:set("seu_net_login", section, "interface", self.map:get(section, "interface"))
    uci:commit("seu_net_login")
    
    -- 执行登录脚本
    local result = sys.exec("/usr/bin/seu_net_login.sh")
    luci.http.write("<script>alert(" .. luci.util.serialize_json(result) .. ");</script>")
end

-- o = s:option(DummyValue, "_log", translate("View Log"))
-- o.rawhtml = true
-- o.value = [[<a href="]] .. luci.dispatcher.build_url("admin", "services", "seu_net_login", "log") .. [[" class="cbi-button cbi-button-apply">]] .. translate("View Log") .. [[</a>]]

return m