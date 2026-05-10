local gs = require("styles.globalstyles")
local colors = require("styles.colors")
local icon_map = require("helpers.icon_map")
local AEROSPACE_ERROR_MSG = "Can't connect to AeroSpace"
local AEROSPACE_ERR_LOG = "Aerospace is not running."
local spaces = {}
local last_focused_workspace = nil
local refresh_in_flight = false
local refresh_queued = false
local queued_focused_workspace = nil

sbar.add("event", "aerospace_workspace_change")

local function trim(value)
	return (value or ""):match("^%s*(.-)%s*$")
end

local function space_name_for(item)
	return item.name:match("^space%.(.*)")
end

local function build_icon_strip(app_icons)
	if not app_icons or #app_icons == 0 then
		return " —"
	end
	local icon_strip = " "
	for _, icon in ipairs(app_icons) do
		icon_strip = icon_strip .. " " .. icon
	end
	return icon_strip
end

local function parse_workspace_displays(output)
	local displays = {}
	for line in output:gmatch("[^\r\n]+") do
		local workspace, display = line:match("^([^|]+)|([^|]+)$")
		if workspace and display then
			displays[trim(workspace)] = trim(display)
		end
	end
	return displays
end

local function parse_workspace_icons(output)
	local icons_by_space = {}
	for line in output:gmatch("[^\r\n]+") do
		local workspace, app = line:match("^([^|]+)|(.+)$")
		if workspace and app then
			workspace = trim(workspace)
			app = trim(app)
			if icons_by_space[workspace] == nil then
				icons_by_space[workspace] = {}
			end
			table.insert(icons_by_space[workspace], icon_map[app] or icon_map["Default"])
		end
	end
	return icons_by_space
end

local refresh_all_spaces

local function finish_refresh()
	refresh_in_flight = false
	if not refresh_queued then
		return
	end

	local focused_workspace = queued_focused_workspace

	refresh_queued = false
	queued_focused_workspace = nil
	refresh_all_spaces(focused_workspace)
end

local function apply_refresh(workspace_output, window_output, focused_workspace)
	local displays = parse_workspace_displays(workspace_output)
	local icons_by_space = parse_workspace_icons(window_output)
	local focus_changed = focused_workspace ~= last_focused_workspace

	for _, space in ipairs(spaces) do
		local space_name = space_name_for(space)
		local is_focused = space_name == focused_workspace
		local icon_strip = build_icon_strip(icons_by_space[space_name])
		local should_draw = icon_strip ~= " —" or is_focused
		local background = {
			color = colors.highlight,
			y_offset = is_focused and -12 or -20,
		}

		space:set({
			display = displays[space_name] or 1,
			drawing = should_draw,
			icon = { highlight = is_focused },
			label = {
				string = icon_strip,
				highlight = is_focused,
			},
		})

		if focus_changed and (space_name == last_focused_workspace or space_name == focused_workspace) then
			sbar.animate("tanh", 15, function()
				space:set({ background = background })
			end)
		else
			space:set({ background = background })
		end
	end

	last_focused_workspace = focused_workspace

	finish_refresh()
end

refresh_all_spaces = function(focused_workspace)
	if refresh_in_flight then
		refresh_queued = true
		queued_focused_workspace = focused_workspace or queued_focused_workspace
		return
	end

	refresh_in_flight = true

	sbar.exec(
		"aerospace list-workspaces --all --format '%{workspace}|%{monitor-appkit-nsscreen-screens-id}'",
		function(workspace_output)
			if workspace_output:find(AEROSPACE_ERROR_MSG, 1, true) then
				print(AEROSPACE_ERR_LOG)
				finish_refresh()
				return
			end

			sbar.exec("aerospace list-windows --all --format '%{workspace}|%{app-name}'", function(window_output)
				if window_output:find(AEROSPACE_ERROR_MSG, 1, true) then
					print(AEROSPACE_ERR_LOG)
					finish_refresh()
					return
				end

				if focused_workspace and focused_workspace ~= "" then
					apply_refresh(workspace_output, window_output, trim(focused_workspace))
					return
				end

				sbar.exec("aerospace list-workspaces --focused --format '%{workspace}'", function(focused_output)
					apply_refresh(workspace_output, window_output, trim(focused_output))
				end)
			end)
		end
	)
end

local workspace_output = io.popen("aerospace list-workspaces --all --format '%{workspace}' 2>&1"):read("*a")

assert(workspace_output:find(AEROSPACE_ERROR_MSG, 1, true) == nil, AEROSPACE_ERR_LOG)

for space_name in workspace_output:gmatch("[^\r\n]+") do
	space_name = trim(space_name)
	local space = sbar.add("space", "space." .. space_name, gs.defaults.space)
	space:set({
		icon = space_name,
		click_script = "aerospace workspace " .. space_name,
		label = " —",
	})
	table.insert(spaces, space)
end

refresh_all_spaces()

sbar.add("item", "spaces.workspace_event_listner", { drawing = false, updates = true })
	:subscribe("aerospace_workspace_change", function(env)
		refresh_all_spaces(env.FOCUSED_WORKSPACE)
	end)
sbar.add("item", "spaces.windows_event_listner", { drawing = false, updates = true })
	:subscribe("space_windows_change", function()
		refresh_all_spaces()
	end)
