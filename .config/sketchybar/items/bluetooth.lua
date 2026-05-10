local gs = require("styles.globalstyles")
local colors = require("styles.colors")

local device_items = {}

local function printTable(t, indent)
	indent = indent or 0
	for k, v in pairs(t) do
		local formatting = string.rep("  ", indent) .. k .. ": "
		if type(v) == "table" then
			print(formatting)
			printTable(v, indent + 1)
		else
			print(formatting .. tostring(v))
		end
	end
end

local function get_device_icon(minor_type)
	local icon_map = {
		["Speaker"] = "󰓃",
		["Headphones"] = "",
		["Mouse"] = "󰍽",
		["Magic Trackpad"] = "󰟸",
	}

	return icon_map[minor_type] or "󰂯"
end

local function render_device_items(devices, is_clicked)
	for _, device_item in pairs(device_items) do
		sbar.remove(device_item.name)
	end

	device_items = {}

	for cnt, device in ipairs(devices) do
		local device_color = device.connected and colors.green or colors.label_color
		local new_device = sbar.add("item", "bluetooth.device" .. cnt, gs.defaults.menu_item)
		local script = device.connected and "blueutil --disconnect " .. device.address
			or "blueutil --connect " .. device.address

		new_device:set({
			position = "popup.bluetooth",
			label = {
				string = device.name,
				color = device_color,
			},
			click_script = script
				.. "; sketchybar --trigger bluetooth_status_change updated_device=bluetooth.device"
				.. cnt,
		})

		new_device:subscribe("mouse.entered", function()
			new_device:set({ label = { color = colors.highlight } })
		end)
		new_device:subscribe("mouse.exited", function()
			new_device:set({ label = { color = device_color } })
		end)

		table.insert(device_items, new_device)
	end

	if is_clicked then
		sbar.exec("sketchybar --set bluetooth popup.drawing=toggle")
	end
end

local function refresh_devices(is_clicked)
	sbar.exec("system_profiler SPBluetoothDataType -json | cat", function(output)
		if output == nil or output == "" then
			return
		end

		local fetched_data = output.SPBluetoothDataType[1]

		if fetched_data == nil then
			return
		end

		local devices = {}

		if fetched_data.device_connected ~= nil then
			for _, obj in ipairs(fetched_data.device_connected) do
				for device, info in pairs(obj) do
					if info.device_minorType == nil then
						goto continue
					end

					local device_icon = get_device_icon(info.device_minorType)
					local new_device = {
						name = device_icon .. "\t" .. device,
						address = info.device_address,
						connected = true,
						paired = true,
						minor_type = info.device_minorType,
					}
					table.insert(devices, new_device)

					::continue::
				end
			end
		end

		if fetched_data.device_not_connected ~= nil then
			for _, obj in ipairs(fetched_data.device_not_connected) do
				for device, info in pairs(obj) do
					if info.device_minorType == nil then
						goto continue
					end

					local device_icon = get_device_icon(info.device_minorType)
					local new_device = {
						name = device_icon .. "\t" .. device,
						address = info.device_address,
						connected = false,
						paired = true,
						minor_type = info.device_minorType,
					}
					table.insert(devices, new_device)

					::continue::
				end
			end
		end

		render_device_items(devices, is_clicked)
	end)
end

refresh_devices(false)

sbar.add("event", "bluetooth_power_change")
sbar.add("event", "bluetooth_status_change")

local bt = sbar.add("item", "bluetooth", {
	position = "right",
	icon = {
		string = "󰂯",
		color = colors.icon_color,
		font = gs.font .. ":Black:28.0",
	},
	label = {
		drawing = false,
	},
	popup = {
		align = "right",
	},
	updates = "when_shown",
})

bt:set(gs.defaults.menu)

local power = sbar.add("item", "bluetooth_power", {
	position = "popup.bluetooth",
	icon = {
		string = "Bluetooth",
		color = colors.label_color,
		padding_left = 15,
		padding_right = 180,
		font = { style = "Bold", size = 13 },
	},
	label = {
		string = "",
		color = colors.green,
		padding_right = 15,
		font = {
			size = 25,
		},
	},
	click_script = "blueutil -p toggle; sketchybar --trigger bluetooth_power_change",
})

power:set(gs.separator)
power:set({
	background = {
		height = 1,
		color = colors.white_25,
		y_offset = -16,
	},
	width = 300,
})

bt:subscribe("bluetooth_power_change", function()
	sbar.exec("blueutil -p", function(output)
		if output:match("1") then
			bt:set({ icon = { string = "󰂯", color = colors.icon_color } })
			power:set({
				label = {
					string = "",
					color = colors.green,
				},
				width = "dynamic",
			})
		else
			bt:set({ icon = { string = "󰂲", color = colors.icon_color_inactive } })
			power:set({
				label = {
					string = "",
					color = colors.label_color,
				},
			})
		end
	end)
end)

bt:subscribe("mouse.exited.global", function()
	bt:set({ popup = { drawing = false } })
end)

bt:subscribe("bluetooth_status_change", function(env)
	local device_color = string.format("0x%08x", colors.label_color) == sbar.query(env.updated_device).label.color
			and colors.green
		or colors.label_color
	sbar.set(env.updated_device, { label = { color = device_color } })
	sbar.subscribe(env.updated_device, "mouse.exited", function()
		sbar.set(env.updated_device, { label = { color = device_color } })
	end)
end)

bt:subscribe("mouse.clicked", function()
	refresh_devices(true)
end)
