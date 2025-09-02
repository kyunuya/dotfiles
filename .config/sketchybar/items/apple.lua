local gs = require("styles.globalstyles")

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

local about = sbar.add("item", "logo.about", gs.defaults.menu_item)
about:set({
	position = "popup." .. apple.name,
	label = { string = "About This Mac" },
	icon = { string = "􀅴" },
	click_script = "open x-apple.systempreferences:com.apple.SystemProfiler.AboutExtension;" .. popup_off,
})
about:set(gs.separator)

local settings = sbar.add("item", "logo.settings", gs.defaults.menu_item)
settings:set({
	position = "popup." .. apple.name,
	label = { string = "System Settings…" },
	icon = { string = "􀍟" },
	click_script = "open -a 'System Settings';" .. popup_off,
})

local sleep = sbar.add("item", "logo.sleep", gs.defaults.menu_item)
sleep:set({
	position = "popup." .. apple.name,
	label = { string = "Sleep" },
	icon = { string = "􀜚" },
	click_script = "pmset sleepnow;" .. popup_off,
})

local restart = sbar.add("item", "logo.restart", gs.defaults.menu_item)
restart:set({
	position = "popup." .. apple.name,
	label = { string = "Restart…" },
	icon = { string = "􀣨" },
	click_script = "osascript -e 'tell app \"loginwindow\" to «event aevtrrst»';" .. popup_off,
})

local shutdown = sbar.add("item", "logo.shutdown", gs.defaults.menu_item)
shutdown:set({
	position = "popup." .. apple.name,
	label = { string = "Shut Down…" },
	icon = { string = "􀷃" },
	click_script = "osascript -e 'tell app \"loginwindow\" to «event aevtrsdn»';" .. popup_off,
})

local locK_screen = sbar.add("item", "logo.lock_screen", gs.defaults.menu_item)
locK_screen:set({
	position = "popup." .. apple.name,
	label = { string = "Lock Screen" },
	icon = { string = "􀼑" },
	click_script = 'osascript -e \'tell application "System Events" to keystroke "q" using {command down,control down}\';'
		.. popup_off,
})

local logout = sbar.add("item", "logo.logout ", gs.defaults.menu_item)
logout:set({
	position = "popup." .. apple.name,
	label = { string = "Log Out " .. os.getenv("USER") .. "…" },
	icon = { string = "􀉭" },
	click_script = "osascript -e 'tell app \"System Events\" to log out';" .. popup_off,
})
logout:set(gs.separator)

local refresh = sbar.add("item", "logo.refresh", gs.defaults.menu_item)
refresh:set({
	position = "popup." .. apple.name,
	label = { string = "Refresh Sketchybar" },
	icon = { string = "􀅈" },
	click_script = popup_off .. "; sketchybar --update",
})
