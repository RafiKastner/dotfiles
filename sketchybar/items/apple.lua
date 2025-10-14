local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local helpers = require("../helpers/functions/helper_funcs")

-- Padding item required because of bracket
sbar.add("item", { width = 5 })

local apple = sbar.add("item", "apple", {
	icon = {
		padding_right = 8,
		padding_left = 8,
	},
	label = { drawing = false },
	background = {
		color = colors.transparent,
		border_color = colors.black,
		border_width = 1,
	},
	padding_right = 1,
})

local SPACES = {
	name = "spaces",
	icon = {
		string = icons.apple,
		font = { size = 18 },
		color = colors.blue,
	},
	background = {
		color = colors.bg0,
	},
	padding_left = 12,
	padding_right = 0,
}
local MENUS = {
	name = "menus",
	icon = {
		string = icons.apple,
		font = { size = 16 },
		color = colors.white,
	},
	background = {
		color = colors.transparent,
	},
	padding_left = 1,
	padding_right = -4,
}
local SERVICE = {
	name = "service",
	icon = {
		string = icons.hammer_wrench,
		font = { size = 16 },
	},
}

local state = SPACES
local aerospace_mode = "main"
sbar.trigger("export_state", { STATE = state })

local function render()
	local s = aerospace_mode == "main" and state or SERVICE
	local t = helpers.shallow_copy(s)
	t.name = nil
	sbar.animate("circ", 10, function()
		apple:set(t)
	end)
end
render()

apple:subscribe("aerospace_mode_change", function(env)
	aerospace_mode = env.NEW_MODE
	render()
end)

local function mode_change(new_mode)
	sbar.exec("aerospace mode " .. new_mode)
	sbar.trigger("aerospace_mode_change", { NEW_MODE = new_mode })
end

local function swap_menus_and_spaces(new_state)
	state = new_state == "spaces" and SPACES or MENUS
	render() --wont render correct if swapped with aerosapce alt-shift-e cause the other listeners dont know the state if nil
end

apple:subscribe("swap_menus_and_spaces", function(env)
	local new_state = env.NEW_STATE
	if new_state == nil then
		new_state = state == MENUS and SPACES.name or MENUS.name
	end
	swap_menus_and_spaces(new_state)
end)

local open = false
apple:subscribe("mouse.clicked", function(env)
	if env.BUTTON == "right" then
		if aerospace_mode == "main" then
			mode_change("service")
		else
			mode_change("main")
		end
	elseif env.BUTTON == "left" then
		if env.MODIFIER == "shift" then
			local name = state == MENUS and SPACES.name or MENUS.name
			sbar.trigger("swap_menus_and_spaces", { NEW_STATE = name })
		else
			sbar.trigger("any_menu_clicked", { MENU_NAME = "apple" })
			if not open then
				sbar.exec("$CONFIG_DIR/helpers/menus/bin/menus -s 0")
			end
			open = not open
		end
	end
end)
apple:subscribe("any_menu_clicked", function(env)
	if env.MENU_NAME ~= "apple" then
		open = false
	end
end)

-- Double border for apple using a single item bracket
sbar.add("bracket", { apple.name }, {
	background = {
		color = colors.transparent,
		height = 30,
		border_color = colors.grey,
	},
})

-- Padding item required because of bracket
sbar.add("item", { width = 7 })
