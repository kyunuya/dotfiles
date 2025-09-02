local gs = require("styles.globalstyles")
local colors = require("styles.colors")
local icons = require("helpers.icon")

local battery = sbar.add("item", "battery", {
	position = "right",
	icon = {
		font = {
			size = 16,
			style = "Light",
		},
	},
	update_freq = 60,
	click_script = "sketchybar --set battery popup.drawing=toggle",
})
battery:set(gs.defaults.icon)
battery:set(gs.defaults.menu)

local remaining_time = sbar.add("item", gs.defaults.menu_item)
remaining_time:set({
	position = "popup." .. battery.name,
	icon = { drawing = false },
	align = "center",
})

battery:subscribe({ "routine", "power_source_change", "system_woke" }, function()
	sbar.exec("pmset -g batt", function(batt_info)
		local icon = "!"

		local found, _, charge = batt_info:find("(%d+)%%")
		if found then
			charge = tonumber(charge)
		end

		local color = colors.label_color
		local charging, _, _ = batt_info:find("AC Power")

		if charging then
			icon = icons.battery.charging
			color = colors.green
		else
			if found and charge > 80 then
				icon = icons.battery._100
				color = colors.green
			elseif found and charge > 60 then
				icon = icons.battery._75
				color = colors.green
			elseif found and charge > 40 then
				icon = icons.battery._50
				color = colors.yellow
			elseif found and charge > 30 then
				icon = icons.battery._50
				color = colors.yellow
			elseif found and charge > 20 then
				icon = icons.battery._25
				color = colors.red
			else
				icon = icons.battery._0
				color = colors.red
			end
		end

		battery:set({
			label = {
				string = tostring(charge) .. "%",
				drawing = true,
			},
			icon = {
				string = icon,
				color = color,
			},
		})
	end)
end)

battery:subscribe({ "mouse.entered", "mouse.exited", "mouse.clicked" }, function()
	battery:set({ popup = { drawing = "toggle" } })
	local drawing = battery:query().popup.drawing

	if drawing == "on" then
		sbar.exec("pmset -g batt", function(batt_info)
			local found, _, remaining = batt_info:find(" (%d+:%d+) remaining")
			local label = found and (remaining == "0:00" and "Fully Charged" or remaining .. " remaining")
				or "No estimate"
			remaining_time:set({ label = { string = label } })
		end)
	end
end)
