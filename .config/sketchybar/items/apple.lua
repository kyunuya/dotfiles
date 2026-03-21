local gs = require("styles.globalstyles")
local colors = require("styles.colors")

local popup_off = "sketchybar --set logo popup.drawing=off"

local apple = sbar.add("item", "logo", gs.defaults.menu)
apple:set({
	icon = {
		string = "􀣺",
		font = gs.font .. ":Black:14.0",
	},
	label = { drawing = false },
	popup = { align = "left" },
	click_script = "sketchybar --set logo popup.drawing=toggle",
})
apple:subscribe("mouse.exited.global", function()
	apple:set({ popup = { drawing = false } })
end)

local about = sbar.add("item", "logo.about", gs.defaults.menu_item)
about:set({
	position = "popup." .. apple.name,
	label = { string = "About This Mac" },
	icon = { string = "􀅴" },
	click_script = "open x-apple.systempreferences:com.apple.SystemProfiler.AboutExtension;" .. popup_off,
})
about:set(gs.separator)
about:subscribe("mouse.entered", function()
	about:set({ label = { color = colors.highlight } })
end)
about:subscribe("mouse.exited", function()
	about:set({ label = { color = colors.label_color } })
end)

local settings = sbar.add("item", "logo.settings", gs.defaults.menu_item)
settings:set({
	position = "popup." .. apple.name,
	label = { string = "System Settings…" },
	icon = { string = "􀍟" },
	click_script = "open -a 'System Settings';" .. popup_off,
})
settings:subscribe("mouse.entered", function()
	settings:set({ label = { color = colors.highlight } })
end)
settings:subscribe("mouse.exited", function()
	settings:set({ label = { color = colors.label_color } })
end)

local sleep = sbar.add("item", "logo.sleep", gs.defaults.menu_item)
sleep:set({
	position = "popup." .. apple.name,
	label = { string = "Sleep" },
	icon = { string = "􀜚" },
	click_script = "pmset sleepnow;" .. popup_off,
})
sleep:subscribe("mouse.entered", function()
	sleep:set({ label = { color = colors.highlight } })
end)
sleep:subscribe("mouse.exited", function()
	sleep:set({ label = { color = colors.label_color } })
end)

local restart = sbar.add("item", "logo.restart", gs.defaults.menu_item)
restart:set({
	position = "popup." .. apple.name,
	label = { string = "Restart…" },
	icon = { string = "􀣨" },
	click_script = "osascript -e 'tell app \"loginwindow\" to «event aevtrrst»';" .. popup_off,
})
restart:subscribe("mouse.entered", function()
	restart:set({ label = { color = colors.highlight } })
end)
restart:subscribe("mouse.exited", function()
	restart:set({ label = { color = colors.label_color } })
end)

local shutdown = sbar.add("item", "logo.shutdown", gs.defaults.menu_item)
shutdown:set({
	position = "popup." .. apple.name,
	label = { string = "Shut Down…" },
	icon = { string = "􀷃" },
	click_script = "osascript -e 'tell app \"loginwindow\" to «event aevtrsdn»';" .. popup_off,
})
shutdown:subscribe("mouse.entered", function()
	shutdown:set({ label = { color = colors.highlight } })
end)
shutdown:subscribe("mouse.exited", function()
	shutdown:set({ label = { color = colors.label_color } })
end)

local lock_screen = sbar.add("item", "logo.lock_screen", gs.defaults.menu_item)
lock_screen:set({
	position = "popup." .. apple.name,
	label = { string = "Lock Screen" },
	icon = { string = "􀼑" },
	click_script = 'osascript -e \'tell application "System Events" to keystroke "q" using {command down,control down}\';'
		.. popup_off,
})
lock_screen:subscribe("mouse.entered", function()
	lock_screen:set({ label = { color = colors.highlight } })
end)
lock_screen:subscribe("mouse.exited", function()
	lock_screen:set({ label = { color = colors.label_color } })
end)

local logout = sbar.add("item", "logo.logout ", gs.defaults.menu_item)
logout:set({
	position = "popup." .. apple.name,
	label = { string = "Log Out " .. os.getenv("USER") .. "…" },
	icon = { string = "􀉭" },
	click_script = "osascript -e 'tell app \"System Events\" to log out';" .. popup_off,
})
logout:set(gs.separator)
logout:subscribe("mouse.entered", function()
	logout:set({ label = { color = colors.highlight } })
end)
logout:subscribe("mouse.exited", function()
	logout:set({ label = { color = colors.label_color } })
end)

local refresh = sbar.add("item", "logo.refresh", gs.defaults.menu_item)
refresh:set({
	position = "popup." .. apple.name,
	label = { string = "Refresh Sketchybar" },
	icon = { string = "􀅈" },
	click_script = popup_off .. "; sketchybar --update",
})
refresh:subscribe("mouse.entered", function()
	refresh:set({ label = { color = colors.highlight } })
end)
refresh:subscribe("mouse.exited", function()
	refresh:set({ label = { color = colors.label_color } })
end)
