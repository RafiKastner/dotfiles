local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local item_order = ""

sbar.exec("aerospace list-workspaces --monitor 1", function(spaces)
	for space_name in spaces:gmatch("[^\r\n]+") do
		local space_number = sbar.add("item", "space_number." .. space_name, {
			icon = {
				font = { family = settings.font },
				string = space_name, --string.sub(space_name, 3),
				padding_left = 6,
				padding_right = 0,
				color = colors.white,
			},
			background = {
				color = colors.transperent,
				border_width = 0,
			},
		})

		SPACE_PADDING_DEFAULT = {
			LEFT = -10,
			RIGHT = -2,
		}
		SPACE_PADDING_SELECTED = {
			LEFT = -2,
			RIGHT = 1,
		}
		local space = sbar.add("item", "space." .. space_name, {
			label = {
				padding_right = 12,
				color = colors.surface2,
				highlight_color = colors.crust,
				font = "sketchybar-app-font:Regular:16.0",
				y_offset = -1,
			},
			padding_right = SPACE_PADDING_DEFAULT.RIGHT,
			padding_left = SPACE_PADDING_DEFAULT.LEFT,
			background = {
				color = colors.blue,
				border_width = 0,
				border_color = colors.white,
				drawing = false,
			},
		})

		local space_bracket = sbar.add("bracket", "space_bracket." .. space_name, { space_number.name, space.name }, {
			background = {
				color = colors.bg0,
				border_width = 0,
			},
		})

		-- Padding space
		local space_padding = sbar.add("item", "space.padding." .. space_name, {
			script = "",
			width = settings.group_paddings,
		})

		local first_render = true
		local should_draw = "on"
		local state = "spaces"

		local function updateSpaceWindows()
			sbar.exec( --delay because aerospace & macos combo unreliable regarding window closed
				--events & maintaining focus on current workspace
				"sleep .05 && aerospace list-windows --format %{app-name} --workspace " .. space_name,
				function(windows)
					local no_app = true
					local icon_line = ""
					for app in windows:gmatch("[^\r\n]+") do
						no_app = false
						local lookup = app_icons[app]
						local icon = ((lookup == nil) and app_icons["default"] or lookup)
						icon_line = icon_line .. icon .. " "
					end

					if no_app then
						if should_draw == "off" or first_render then
							should_draw = "off"
							first_render = false
							space_bracket:set({ updates = true, drawing = false })
							space:set({ updates = true, drawing = false })
							space_number:set({ updates = true, drawing = false })
							space_padding:set({ drawing = false })
						end
						icon_line = "—"
					end

					sbar.animate("tanh", 10, function()
						space:set({ label = icon_line })
					end)
				end
			)
		end

		local function updateSelectedWorkspace(env)
			if state ~= "spaces" then
				return
			end

			local selected = env.FOCUSED_WORKSPACE == space_name
			space:set({
				label = { highlight = selected },
				background = { drawing = selected },
				drawing = selected or should_draw,
			})
			space_bracket:set({ drawing = selected or should_draw })
			space_number:set({ drawing = selected or should_draw })
			space_padding:set({ drawing = selected or should_draw })

			sbar.animate("sin", 8, function()
				space:set({
					padding_left = selected and SPACE_PADDING_SELECTED.LEFT or SPACE_PADDING_DEFAULT.LEFT,
					padding_right = selected and SPACE_PADDING_SELECTED.RIGHT or SPACE_PADDING_DEFAULT.RIGHT,
				})
			end)
			--[[space_bracket:set({
				background = { border_color = selected and colors.grey or colors.bg2 },
			})]]
		end
		-- initial setup
		updateSpaceWindows()
		local function setupSelectedWorkspace()
			sbar.exec("aerospace list-workspaces --focused", function(result)
				updateSelectedWorkspace({ FOCUSED_WORKSPACE = result:gsub("[\n\r]", "") }) --idk why bot working
			end)
		end
		setupSelectedWorkspace()

		-- custom trigger
		space:subscribe("aerospace_workspace_change", function(env)
			sbar.exec("aerospace list-workspaces --focused", function()
				updateSelectedWorkspace(env)
			end)
		end)

		--BUG: space_windows_change event does not fire when you
		--close the last window in an aerosapce workspace

		--should refresh when window sent to another workspace
		--and then display said workspace (and when look in to it even if empty)
		--and want to be able to toggle if view them
		--[[
        each should have should_view property
        if we find it has no apps in the update func, set 
    --]]

		space_number:subscribe("workspace_visual_rename", function(env)
			sbar.exec("aerospace list-workspaces --focused", function(focused_workspace)
				local workspace = env.TO_RENAME or focused_workspace:gsub("[\r\n]", "")
				print(workspace)
				if workspace == space_name then
					space_number:set({
						icon = {
							string = env.NEW_WORKSPACE_NAME,
						},
					})
				end
			end)
		end)

		space:subscribe("show_workspace", function(env)
			if space_name == env.WORKSPACE_NAME then
				should_draw = env.SHOULD_DISPLAY or "on"
				space_bracket:set({
					drawing = should_draw,
					updates = true,
				})
				space:set({
					drawing = should_draw,
					updates = true,
				})
				space_number:set({
					drawing = should_draw,
					updates = true,
				})
				space_padding:set({ drawing = should_draw })
			end
		end)

		space:subscribe("mouse.clicked", function()
			sbar.exec("aerospace workspace " .. space_name)
		end)
		space_number:subscribe("mouse.clicked", function()
			sbar.exec("aerospace workspace " .. space_name)
		end)

		space:subscribe("space_windows_change", function()
			updateSpaceWindows()
		end)

		space:subscribe("swap_menus_and_spaces", function(env)
			state = env.NEW_STATE
			sbar.animate("sin", 20, function()
				local drawing = "off"
				if state == "spaces" then
					drawing = should_draw
				end
				space:set({ drawing = drawing, updates = "on" })
				space_number:set({ drawing = drawing, updates = "on" })
				space_padding:set({ drawing = drawing, updates = "on" })
			end)
			if state == "spaces" then
				setupSelectedWorkspace()
			end
		end)

		item_order = item_order .. " " .. space.name .. " " .. space_padding.name
	end
	sbar.exec("sketchybar --reorder apple " .. item_order) -- .. " front_app")
end)
