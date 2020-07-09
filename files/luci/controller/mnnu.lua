module("luci.controller.mnnu", package.seeall)
function index()
        entry({"admin", "network", "mnnu"}, cbi("mnnu/mnnu"), _("闽南师大"), 1000).dependent=false
end