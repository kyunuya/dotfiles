-- v2
local gs = require("styles.globalstyles")
local colors = require("styles.colors")
local popup_off = "sketchybar --set wifi popup.drawing=off"
local popup_click_script = "sketchybar --set wifi popup.drawing=toggle"
local ip_val = ""
local ssid_val = ""
local wifi_device = nil
local refresh_in_flight = false
local refresh_queued = false
local wifi
local ssid
local ip_address

local refresh_wifi
local function trim(value)
	return (value or ""):match("^%s*(.-)%s*$")
end

local function shell_quote(value)
	return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end

local function popup(action)
	wifi:set({ popup = { drawing = action } })
end

local function render_bar_item()
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
		click_script = ssid_val ~= "" and popup_click_script or "",
	})
end

local function render_popup()
	ssid:set({
		label = ssid_val ~= "" and ssid_val or "",
	})
	ip_address:set({
		label = ip_val ~= "" and ip_val or "",
		click_script = ip_val ~= "" and ("printf %s " .. shell_quote(ip_val) .. " | pbcopy; " .. popup_off)
			or popup_off,
	})
end

local function resolve_wifi_device(callback)
	if wifi_device ~= nil then
		callback(wifi_device)
		return
	end
	sbar.exec("networksetup -listallhardwareports", function(output)
		local hardware_ports = output or ""
		local detected_device = trim(hardware_ports:match("Hardware Port:%s*Wi%-Fi%s+Device:%s*(%S+)"))
		if detected_device == "" then
			detected_device = trim(hardware_ports:match("Hardware Port:%s*AirPort%s+Device:%s*(%S+)"))
		end
		wifi_device = detected_device ~= "" and detected_device or "en0"
		callback(wifi_device)
	end)
end

local function apply_summary(summary)
	local output = "\n" .. (summary or "")
	ssid_val = trim(output:match("\n%s*SSID%s*:%s*([^\r\n]+)"))
	ip_val = trim(output:match("Addresses%s*:%s*<array>%s*{%s*0%s*:%s*([^\r\n%s}]+)"))
	render_bar_item()
	render_popup()
end

local function finish_refresh()
	refresh_in_flight = false
	if not refresh_queued then
		return
	end
	refresh_queued = false
	refresh_wifi()
end

refresh_wifi = function()
	if refresh_in_flight then
		refresh_queued = true
		return
	end
	refresh_in_flight = true
	resolve_wifi_device(function(device)
		sbar.exec("ipconfig getsummary " .. device .. " 2>/dev/null", function(summary_output)
			apply_summary(summary_output)
			finish_refresh()
		end)
	end)
end

wifi = sbar.add("item", "wifi", {
	position = "right",
	label = {
		drawing = false,
	},
	popup = {
		align = "right",
	},
	updates = "when_shown",
	click_script = popup_off,
})
wifi:set(gs.defaults.menu)

ssid = sbar.add("item", "wifi.ssid", {
	position = "popup." .. wifi.name,
	icon = "􀅴",
	label = "SSID",
	click_script = "open 'x-apple.systempreferences:com.apple.preference.network?Wi-Fi';" .. popup_off,
})
ssid:set(gs.defaults.menu_item)

ip_address = sbar.add("item", "wifi.ipaddress", {
	position = "popup." .. wifi.name,
	icon = "􀆪",
	label = "IP Address",
	click_script = popup_off,
})
ip_address:set(gs.defaults.menu_item)

wifi:subscribe("mouse.entered", function()
	popup("on")
end)
wifi:subscribe({ "mouse.exited", "mouse.exited.global" }, function()
	popup("off")
end)
wifi:subscribe({ "system_woke", "routine", "wifi_change", "forced" }, function()
	refresh_wifi()
end)

refresh_wifi()

-- v3 (wifi power state, nearby known networks, and some refactoring)
-- local gs = require("styles.globalstyles")
-- local colors = require("styles.colors")
-- local popup_off = "sketchybar --set wifi popup.drawing=off"
-- local ip_val = ""
-- local ssid_val = ""
-- local wifi_device = nil
-- local wifi_power = "off"
-- local known_network_items = {}
-- local refresh_in_flight = false
-- local refresh_queued = false
-- local wifi
-- local ssid
-- local ip_address
-- local power
-- local known_header
-- local refresh_wifi
-- local function trim(value)
-- 	return (value or ""):match("^%s*(.-)%s*$")
-- end
-- local function shell_quote(value)
-- 	return "'" .. tostring(value or ""):gsub("'", "'\\''") .. "'"
-- end
-- local function popup(action)
-- 	wifi:set({ popup = { drawing = action } })
-- end
-- local function clear_known_network_items()
-- 	for _, item in ipairs(known_network_items) do
-- 		item:set({ drawing = false })
-- 	end
-- end
-- local function ensure_known_network_item(index)
-- 	if known_network_items[index] ~= nil then
-- 		return known_network_items[index]
-- 	end
-- 	local item = sbar.add("item", "wifi.known." .. index, {
-- 		position = "popup." .. wifi.name,
-- 		icon = "􀉣",
-- 		label = "",
-- 		click_script = "",
-- 	})
-- 	item:set(gs.defaults.menu_item)
-- 	known_network_items[index] = item
-- 	return item
-- end
-- local function render_bar_item()
-- 	local icon_color, icon
-- 	if wifi_power ~= "on" then
-- 		icon_color = colors.red
-- 		icon = "􀐾"
-- 	elseif ssid_val == "Ebrietas" then
-- 		icon_color = colors.white
-- 		icon = "􀉤"
-- 	elseif ssid_val ~= "" then
-- 		icon_color = colors.white
-- 		icon = "􀐿"
-- 	else
-- 		icon_color = colors.yellow
-- 		icon = "􀐾"
-- 	end
-- 	wifi:set({
-- 		icon = {
-- 			string = icon,
-- 			color = icon_color,
-- 		},
-- 		click_script = "networksetup -setairportpower "
-- 			.. wifi_device
-- 			.. " "
-- 			.. (wifi_power == "on" and "off" or "on")
-- 			.. "; sketchybar --trigger wifi_change",
-- 	})
-- end
-- local function render_popup(nearby_known_networks)
-- 	ssid:set({
-- 		label = ssid_val ~= "" and ssid_val or (wifi_power == "on" and "Not connected" or "Wi-Fi Off"),
-- 	})
-- 	ip_address:set({
-- 		label = ip_val ~= "" and ip_val or "No IP",
-- 		click_script = ip_val ~= "" and ("printf %s " .. shell_quote(ip_val) .. " | pbcopy; " .. popup_off)
-- 			or popup_off,
-- 	})
-- 	power:set({
-- 		label = wifi_power == "on" and "On" or "Off",
-- 		click_script = "networksetup -setairportpower "
-- 			.. wifi_device
-- 			.. " "
-- 			.. (wifi_power == "on" and "off" or "on")
-- 			.. "; sketchybar --trigger wifi_change; "
-- 			.. popup_off,
-- 	})
-- 	clear_known_network_items()
-- 	if wifi_power ~= "on" then
-- 		known_header:set({
-- 			label = "Turn Wi-Fi on to scan nearby networks",
-- 			drawing = true,
-- 		})
-- 		return
-- 	end
-- 	if #nearby_known_networks == 0 then
-- 		known_header:set({
-- 			label = "No nearby known networks",
-- 			drawing = true,
-- 		})
-- 		return
-- 	end
-- 	known_header:set({
-- 		label = "Nearby Known Networks",
-- 		drawing = true,
-- 	})
-- 	for index, network in ipairs(nearby_known_networks) do
-- 		local item = ensure_known_network_item(index)
-- 		local is_current = network == ssid_val
-- 		item:set({
-- 			drawing = true,
-- 			icon = {
-- 				string = is_current and "􀁣" or "􀉣",
-- 				color = is_current and colors.green or colors.highlight,
-- 			},
-- 			label = {
-- 				string = network,
-- 				color = is_current and colors.green or colors.label_color,
-- 			},
-- 			click_script = is_current and popup_off
-- 				or (
-- 					"networksetup -setairportnetwork "
-- 					.. wifi_device
-- 					.. " "
-- 					.. shell_quote(network)
-- 					.. "; sketchybar --trigger wifi_change; "
-- 					.. popup_off
-- 				),
-- 		})
-- 	end
-- end
-- local function resolve_wifi_device(callback)
-- 	if wifi_device ~= nil then
-- 		callback(wifi_device)
-- 		return
-- 	end
-- 	sbar.exec("networksetup -listallhardwareports", function(output)
-- 		local hardware_ports = output or ""
-- 		local detected_device = trim(hardware_ports:match("Hardware Port:%s*Wi%-Fi%s+Device:%s*(%S+)"))
-- 		if detected_device == "" then
-- 			detected_device = trim(hardware_ports:match("Hardware Port:%s*AirPort%s+Device:%s*(%S+)"))
-- 		end
-- 		wifi_device = detected_device ~= "" and detected_device or "en0"
-- 		callback(wifi_device)
-- 	end)
-- end
-- local function parse_known_networks(output)
-- 	local known = {}
-- 	local ordered = {}
-- 	for line in (output or ""):gmatch("[^\r\n]+") do
-- 		local network = trim(line)
-- 		if network ~= "" and not network:match("^Preferred networks on ") then
-- 			if not known[network] then
-- 				known[network] = true
-- 				table.insert(ordered, network)
-- 			end
-- 		end
-- 	end
-- 	return known, ordered
-- end
-- local function parse_nearby_networks_from_profiler(output)
-- 	local nearby = {}
-- 	local seen = {}
-- 	for network_name in (output or ""):gmatch([["_%s*name"%s*:%s*"([^"]+)"]]) do
-- 		local name = trim(network_name)
-- 		if name ~= "" and name ~= "<redacted>" and not seen[name] then
-- 			seen[name] = true
-- 			table.insert(nearby, name)
-- 		end
-- 	end
-- 	return nearby
-- end
-- local function parse_power_and_summary(power_output, summary_output)
-- 	local is_power_on = (power_output or ""):match(": On") ~= nil
-- 	local summary = "\n" .. (summary_output or "")
-- 	wifi_power = is_power_on and "on" or "off"
-- 	ssid_val = trim(summary:match("\n%s*SSID%s*:%s*([^\r\n]+)"))
-- 	ip_val = trim(summary:match("Addresses%s*:%s*<array>%s*{%s*0%s*:%s*([^\r\n%s}]+)"))
-- 	if wifi_power ~= "on" then
-- 		ssid_val = ""
-- 		ip_val = ""
-- 	end
-- end
-- local function finish_refresh()
-- 	refresh_in_flight = false
-- 	if not refresh_queued then
-- 		return
-- 	end
-- 	refresh_queued = false
-- 	refresh_wifi()
-- end
-- refresh_wifi = function()
-- 	if refresh_in_flight then
-- 		refresh_queued = true
-- 		return
-- 	end
-- 	refresh_in_flight = true
-- 	resolve_wifi_device(function(device)
-- 		sbar.exec("networksetup -getairportpower " .. device, function(power_output)
-- 			local summary_cmd = "ipconfig getsummary " .. device .. " 2>/dev/null"
-- 			sbar.exec(summary_cmd, function(summary_output)
-- 				parse_power_and_summary(power_output, summary_output)
-- 				local preferred_cmd = "networksetup -listpreferredwirelessnetworks " .. device
-- 				sbar.exec(preferred_cmd, function(preferred_output)
-- 					local known_set = parse_known_networks(preferred_output)
-- 					local nearby_known_networks = {}
-- 					if wifi_power ~= "on" then
-- 						render_bar_item()
-- 						render_popup(nearby_known_networks)
-- 						finish_refresh()
-- 						return
-- 					end
-- 					sbar.exec("system_profiler SPAirPortDataType -json", function(profiler_output)
-- 						for _, network in ipairs(parse_nearby_networks_from_profiler(profiler_output)) do
-- 							if known_set[network] then
-- 								table.insert(nearby_known_networks, network)
-- 							end
-- 						end
-- 						table.sort(nearby_known_networks, function(a, b)
-- 							if a == ssid_val then
-- 								return true
-- 							end
-- 							if b == ssid_val then
-- 								return false
-- 							end
-- 							return a:lower() < b:lower()
-- 						end)
-- 						render_bar_item()
-- 						render_popup(nearby_known_networks)
-- 						finish_refresh()
-- 					end)
-- 				end)
-- 			end)
-- 		end)
-- 	end)
-- end
-- wifi = sbar.add("item", "wifi", {
-- 	position = "right",
-- 	label = {
-- 		drawing = false,
-- 	},
-- 	popup = {
-- 		align = "right",
-- 	},
-- 	updates = "when_shown",
-- 	click_script = popup_off,
-- })
-- wifi:set(gs.defaults.menu)
-- ssid = sbar.add("item", "wifi.ssid", {
-- 	position = "popup." .. wifi.name,
-- 	icon = "􀅴",
-- 	label = "SSID",
-- 	click_script = "open 'x-apple.systempreferences:com.apple.preference.network?Wi-Fi';" .. popup_off,
-- })
-- ssid:set(gs.defaults.menu_item)
-- ip_address = sbar.add("item", "wifi.ipaddress", {
-- 	position = "popup." .. wifi.name,
-- 	icon = "􀆪",
-- 	label = "IP Address",
-- 	click_script = popup_off,
-- })
-- ip_address:set(gs.defaults.menu_item)
-- power = sbar.add("item", "wifi.power", {
-- 	position = "popup." .. wifi.name,
-- 	icon = "􀛨",
-- 	label = "Power",
-- 	click_script = popup_off,
-- })
-- power:set(gs.defaults.menu_item)
-- known_header = sbar.add("item", "wifi.known_header", {
-- 	position = "popup." .. wifi.name,
-- 	icon = "􀙇",
-- 	label = "",
-- 	click_script = popup_off,
-- })
-- known_header:set(gs.defaults.menu_item)
-- wifi:subscribe("mouse.entered", function()
-- 	popup("on")
-- 	refresh_wifi()
-- end)
-- wifi:subscribe({ "mouse.exited", "mouse.exited.global" }, function()
-- 	popup("off")
-- end)
-- wifi:subscribe({ "system_woke", "routine", "wifi_change", "forced" }, function()
-- 	refresh_wifi()
-- end)
-- refresh_wifi()
