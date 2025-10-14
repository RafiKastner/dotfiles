local colors = require("colors")
local icons = require("icons")
local helpers = require("../helpers/functions/helper_funcs")
local settings = require("settings")

--TODO: Make dropdowns open when you've alrady clicked
--on one and drag over the others they show up
--if you move mouse out of them they disappear but until you
--click anywhere else the property stays

local cache = {}

local function createMenus(drawing)
	sbar.exec("$CONFIG_DIR/helpers/menus/bin/menus -l", function(menus)
		local i = 0
		for menu_name in menus:gmatch("[^\r\n]+") do
			i = i + 1
			cache[i] = menu_name
			local item = sbar.add("item", "menu." .. menu_name, {
				icon = {
					string = menu_name,
					font = {
						family = settings.font_system,
						size = 13,
						style = i == 1 and "Bold" or "Normal",
					},
				},
				drawing = drawing ~= nil and drawing or false,
				updates = true,
				padding_right = 6,
				--padding_left = i == 1 and 10 or 0,
			})
			item:subscribe("swap_menus_and_spaces", function(env)
				--BUG that if NEW_STATR is nil it does not know what to do so it should never be
				local _drawing = env.NEW_STATE == "menus"
				item:set({
					drawing = _drawing,
				})
			end)
			local index = i
			local open = false
			local function openMenu()
				sbar.exec("$CONFIG_DIR/helpers/menus/bin/menus -s " .. index)
			end
			item:subscribe("mouse.clicked", function()
				sbar.trigger("any_menu_clicked", { MENU_NAME = menu_name })
				if not open then
					openMenu()
				end
				open = not open
			end)
			item:subscribe("any_menu_clicked", function(env)
				if env.MENU_NAME ~= menu_name then
					open = false
				end
			end)
			item:subscribe("mouse.entered", function()
				item:set({
					icon = { color = colors.blue },
				})
			end)
			item:subscribe("mouse.exited", function()
				item:set({
					icon = { color = colors.white },
				})
			end)
		end

		sbar.exec("sketchybar --set menu." .. cache[#cache] .. " padding_right=-2")

		local bracket = sbar.add(
			"bracket",
			"menus_bracket",
			helpers.map(cache, function(v)
				return "menu." .. v
			end),
			{
				background = {
					color = colors.bg0,
				},
			}
		)
		table.insert(cache, "menus_bracket")
	end)
end

local function clearMenus()
	for _, name in ipairs(cache) do
		if name == "menus_bracket" then
			sbar.remove(name)
		else
			sbar.remove("menu." .. name)
		end
	end
	cache = {}
end

createMenus()

local manager = sbar.add("item", "menu_manager", {
	drawing = false,
	updates = true,
})

local state = "spaces"
manager:subscribe("swap_menus_and_spaces", function(env)
	state = env.NEW_STATE
end)

manager:subscribe("focus_changed", function()
	clearMenus()
	local drawing = state == "menus"
	createMenus(drawing)
end)
