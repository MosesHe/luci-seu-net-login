module("luci.controller.seu_net_login", package.seeall)

function index()
    entry({"admin", "services", "seu_net_login"}, firstchild(), _("SEU 校园网认证"), 60).dependent = false
    entry({"admin", "services", "seu_net_login", "settings"}, cbi("seu_net_login"), _("设置"), 1)
    entry({"admin", "services", "seu_net_login", "log"}, call("action_log"), _("日志"), 2)
end

function action_log()
    local util = require "luci.util"
    local log_content = util.exec("cat /tmp/seu_net_login.log")
    luci.template.render("seu_net_login/log", {log=log_content})
end