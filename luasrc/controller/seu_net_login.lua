module("luci.controller.seu_net_login", package.seeall)

function index()
    entry({"admin", "services", "seu_net_login"}, cbi("seu_net_login"), _("SEU Net Login"), 60)
    entry({"admin", "services", "seu_net_login", "log"}, call("action_log"), _("Login Log"), 61)
end

function action_log()
    local util = require "luci.util"
    local log_content = util.exec("cat /tmp/seu_net_login.log")
    luci.template.render("seu_net_login/log", {log=log_content})
end