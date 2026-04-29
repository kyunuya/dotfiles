local gs = require("styles.globalstyles")
local colors = require("styles.colors")

local popup_off = "sketchybar --set wifi popup.drawing=off"
local popup_click_script = "sketchybar --set wifi popup.drawing=toggle"

local ip_val = ""
local ssid_val = ""

local function popup(env, action)
	sbar.exec(" sketchybar --set " .. env.NAME .. " popup.drawing=" .. action)
end

local function render_bar_item(wifi)
	local icon_color, icon

	if ssid_val == "Ebrietas" then
		icon_color = colors.white
		icon = "􀉤"
	elseif ssid_val ~= "" then
		icon_color = colors.white
		icon = "􀐿"
	else
		icon_color = colors.red
		icon = "􀐾"
	end

	wifi:set({
		icon = {
			string = icon,
			color = icon_color,
		},
		click_script = popup_click_script,
	})
end

local function render_popup()
	if ssid_val ~= "" then
		sbar.set("wifi", { click_script = popup_click_script })
		sbar.set("wifi.ssid", { label = ssid_val })
		sbar.set("wifi.ipaddress", { label = ip_val, click_script = "printf " .. ip_val .. " | pbcopy; " .. popup_off })
	else
		sbar.set("wifi", { click_script = "" })
	end
end

local wifi = sbar.add("item", "wifi", {
	position = "right",
	label = {
		drawing = false,
	},
	popup = {
		align = "right",
	},
	updates = "when_shown",
	-- update_freq = 5,
	click_script = popup_off,
})
wifi:set(gs.defaults.menu)

local ssid = sbar.add("item", "wifi.ssid", {
	position = "popup." .. wifi.name,
	icon = "􀅴",
	label = "SSID",
	click_script = "open 'x-apple.systempreferences:com.apple.preference.network?Wi-Fi';" .. popup_off,
})
ssid:set(gs.defaults.menu_item)

local ip_address = sbar.add("item", "wifi.ipaddress", {
	position = "popup." .. wifi.name,
	icon = "􀆪",
	label = "IP Address",
	click_script = "echo " .. ip_val .. " | pbcopy; " .. popup_off,
})
ip_address:set(gs.defaults.menu_item)

wifi:subscribe({ "mouse.entered" }, function(env)
	popup(env, "on")
end)

wifi:subscribe({ "mouse.exited", "mouse.exited.global" }, function(env)
	popup(env, "off")
end)

wifi:subscribe("mouse.clicked", function(env)
	popup(env, "toggle")
end)

wifi:subscribe({ "system_woke", "routine", "wifi_change", "forced" }, function()
	sbar.exec(
		"ipconfig getsummary $(networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/{getline; print $2}') | awk -F ' SSID : ' '/ SSID : / {print $2}'",
		function(ssid_ouput)
			sbar.exec("ipconfig getifaddr en0", function(ip_output)
				ssid_val = ssid_ouput
				ip_val = ip_output
				render_bar_item(wifi)
				render_popup()
			end)
		end
	)
end)

-- wifi:subscribe({ "routine", "wifi_update", "forced" }, function()
-- 	render_bar_item(wifi)
-- 	render_popup()
-- end)
