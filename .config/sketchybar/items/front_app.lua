local gs = require("styles.globalstyles")

local front_app = sbar.add("item", "front_app", gs.defaults.front_app)
front_app:subscribe("front_app_switched", function(env)
	front_app:set({ label = { string = env.INFO } })
end)
