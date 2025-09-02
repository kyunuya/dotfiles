local gs = require("styles.globalstyles")

local function render_popup()
	if not io.popen("which icalBuddy"):read("*a"):match("icalBuddy") then
		return
	end

	local ical_command =
		"/opt/homebrew/bin/icalBuddy -ec 'Found in Natural Language,CCSF' -npn -nc -iep 'datetime,title' -po 'datetime,title' -eed -ea -n -li 4 -ps '|: |' -b '' eventsToday 2>/dev/null"

	sbar.exec(ical_command, function(input)
		local theEvent = "No events today"

		if input and #input > 0 then
			local currentTime = os.date("%I:%M %p")

			for anEvent in input:gmatch("[^%^]+") do
				local eventTime = anEvent:match("^(.-)|:%s*")
				if eventTime then
					if eventTime > currentTime then
						theEvent = anEvent
						break
					end
				end
			end
		end

		sbar.set("clock.details", {
			label = theEvent,
			click_script = "sketchybar --set clock popup.drawing=off",
		})
	end)
end

local calendar = sbar.add("item", "date", {
	position = "right",
	align = "right",
	update_freq = 60,
	label = {
		font = gs.font .. ":Semibold:10",
		padding_right = 4,
	},
	icon = {
		drawing = false,
	},
	y_offset = 6,
	width = 0,
	click_script = "open -a Calendar.app",
})

calendar:subscribe({ "system_woke", "forced", "routine" }, function()
	sbar.exec('date "+%a, %b %d"', function(date_output)
		local cleaned_date = date_output:gsub("[\r\n]", "")
		sbar.set("date", { label = cleaned_date })
	end)
end)

local clock = sbar.add("item", "clock", gs.defaults.menu)

clock:set({
	position = "right",
	update_freq = 10,
	y_offset = -4,
	icon = { drawing = false },
	label = {
		font = gs.font .. ":Bold:14",
		padding_right = 4,
	},
	align = "right",
	popup = { align = "right" },
	click_script = "sketchybar --set clock popup.drawing=toggle; open -a Calendar.app",
})

local clock_details = sbar.add("item", "clock.details", gs.defaults.menu_item)
clock_details:set({
	position = "popup." .. clock.name,
	icon = { drawing = false },
	label = { padding_left = 0 },
})

clock:subscribe({ "routine", "forced", "system_woke" }, function()
	sbar.exec('date "+%I:%M %p"', function(time_output)
		local cleaned_time = time_output:gsub("[\r\n]", "")
		sbar.set("clock", { label = cleaned_time })
	end)
end)

clock:subscribe({ "mouse.entered", "mouse.exited" }, function()
	clock:set({ popup = { drawing = "toggle" } })
	render_popup()
end)

clock:subscribe({ "mouse.exited" }, function()
	clock:set({ popup = { drawing = false } })
end)
