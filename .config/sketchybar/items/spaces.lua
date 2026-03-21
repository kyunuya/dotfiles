local gs = require("styles.globalstyles")
local icon_map = require("helpers.icon_map")

local AEROSPACE_ERROR_MSG = "Can't connect to AeroSpace"
local AEROSPACE_ERR_LOG = "Aerospace is not running."

local function printTable(t, indent)
	indent = indent or ""
	for k, v in pairs(t) do
		if type(v) == "table" then
			print(indent .. tostring(k) .. ": {")
			printTable(v, indent .. "  ") -- Increase indent for nested tables
			print(indent .. "}")
		else
			print(indent .. tostring(k) .. ": " .. tostring(v))
		end
	end
end

local spaces = {}

sbar.add("event", "aerospace_workspace_change")
sbar.add("event", "aerospace_workspace_switch")

local function update_space(space, space_name, is_focused)
	sbar.exec("aerospace list-windows --format %{app-name} --workspace " .. space_name, function(apps)
		sbar.exec(
			"aerospace list-windows --workspace "
				.. space_name
				.. ' --format "%{monitor-appkit-nsscreen-screens-id}" | head -n 1',
			function(monitor_id)
				-- assert(monitor_id:find(AEROSPACE_ERROR_MSG) == nil, AEROSPACE_ERR_LOG)
				local icon_strip = " "
				for app in apps:gmatch("[^\r\n]+") do
					local icon = icon_map[app] or icon_map["Default"]
					icon_strip = icon_strip .. " " .. icon
				end

				space:set({
					label = icon_strip ~= " " and icon_strip or " —",
					display = monitor_id,
				})

				local offset = is_focused and -12 or -20

				sbar.animate("tanh", 15, function()
					space:set({
						background = {
							color = require("styles.colors").highlight,
							y_offset = offset,
						},
					})
				end)

				local should_draw = icon_strip ~= " " or is_focused
				space:set({
					icon = { highlight = is_focused },
					label = { highlight = is_focused },
					drawing = should_draw,
				})
			end
		)
	end)
end

local function update_all_spaces(env, focused_workspace)
	local focused = env ~= nil and env.FOCUSED_WORKSPACE or focused_workspace or ""

	for _, space in ipairs(spaces) do
		local space_name = space.name:match("^space%.(.*)")
		local is_focused = (space_name == focused)
		update_space(space, space_name, is_focused)
	end
end

local output = io.popen("aerospace list-workspaces --all 2>&1"):read("*a")
assert(output:find(AEROSPACE_ERROR_MSG) == nil, AEROSPACE_ERR_LOG)

for space_name in output:gmatch("[^\r\n]+") do
	local space = sbar.add("space", "space." .. space_name, gs.defaults.space)
	space:set({
		icon = space_name,
		click_script = "aerospace workspace " .. space_name .. " 2>&1",
		label = " —",
	})

	table.insert(spaces, space)
end

update_all_spaces()

sbar.add("item", "spaces.workspace_event_listner", { drawing = false, updates = true })
	:subscribe("aerospace_workspace_change", function(env)
		update_all_spaces(env)
	end)

sbar.add("item", "spaces.windows_event_listner", { drawing = false, updates = true })
	:subscribe("space_windows_change", function(env)
		sbar.exec("sleep 0.2", function()
			-- We still need to check the focus state to update correctly
			sbar.exec("aerospace list-workspaces --focused", function(focused)
				local current_focused = focused:match("^%s*(.-)%s*$")
				update_all_spaces(env, current_focused)
			end)
		end)
	end)

-- TODO: Create local state to track windows in each space to avoid unnecessary updates
