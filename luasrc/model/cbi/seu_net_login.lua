local m, s, o
local sys = require "luci.sys"
local util = require "luci.util"

m = Map("seu_net_login", translate("SEU Network Login"), translate("Configure SEU Network Login"))

s = m:section(TypedSection, "login", translate("Login Settings"))
s.anonymous = true
s.addremove = false

o = s:option(Value, "username", translate("Username"))
o.rmempty = false

o = s:option(Value, "password", translate("Password"))
o.password = true
o.rmempty = false

-- 添加网络接口选择
o = s:option(ListValue, "interface", translate("Network Interface"))

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

o = s:option(Button, "_login", translate("Login Now"))
o.inputstyle = "apply"
o.write = function()
    local result = sys.exec("/usr/bin/seu_net_login.sh")
    luci.http.write("<pre>" .. result .. "</pre>")
end

o = s:option(DummyValue, "_log", translate("View Log"))
o.rawhtml = true
o.value = [[<a href="]] .. luci.dispatcher.build_url("admin", "services", "seu_net_login", "log") .. [[" class="cbi-button cbi-button-apply">]] .. translate("View Log") .. [[</a>]]

return m