local gs = require("styles.globalstyles")
local icon_map = require("helpers.icon_map")

sbar.add("event", "aerospace_workspace_change")
sbar.add("event", "aerospace_workspace_switch")

local function is_focused_workspace(space_name, callback)
	sbar.exec("aerospace list-workspaces --focused", function(focused)
		local current = focused:match("^%s*(.-)%s*$")
		callback(current == space_name)
	end)
end

local function add_windows(space, space_name)
	sbar.exec("aerospace list-windows --format %{app-name} --workspace " .. space_name, function(apps)
		sbar.exec(
			"aerospace list-windows --workspace "
				.. space_name
				.. ' --format "%{monitor-appkit-nsscreen-screens-id}" | head -n 1',
			function(monitor_id)
				local icon_strip = " "
				for app in apps:gmatch("[^\r\n]+") do
					local icon = icon_map[app] or icon_map["Default"]
					icon_strip = icon_strip .. " " .. icon
				end

				space:set({ label = { string = icon_strip ~= " " and icon_strip or " —" }, display = monitor_id })

				is_focused_workspace(space_name, function(is_focused)
					local should_draw = icon_strip ~= " " or is_focused
					space:set({ drawing = should_draw })
				end)
			end
		)
	end)
end

local output = io.popen("aerospace list-workspaces --all"):read("*a")
for space_name in output:gmatch("[^\r\n]+") do
	local space = sbar.add("item", "space." .. space_name, gs.defaults.space)
	space:set({
		icon = space_name,
		click_script = "aerospace workspace " .. space_name,
	})

	add_windows(space, space_name)

	space:subscribe("aerospace_workspace_change", function(env)
		sbar.exec(
			"aerospace list-windows --workspace "
				.. space.name:match("^space%.(.*)")
				.. ' --format "%{monitor-appkit-nsscreen-screens-id}" | head -n 1',
			function(monitor_id)
				local selected = env.FOCUSED_WORKSPACE == space_name

				local offset = selected and -12 or -20

				sbar.animate("tanh", 15, function()
					space:set({
						background = {
							color = require("styles.colors").highlight,
							y_offset = offset,
						},
					})
				end)

				space:set({
					icon = { highlight = selected },
					label = { highlight = selected },
					drawing = space:query().label.value ~= " —" or selected,
					display = monitor_id,
				})
			end
		)
	end)

	space:subscribe("space_windows_change", function()
		sbar.exec("sleep 0.2", function()
			add_windows(space, space_name)
		end)
	end)
end
