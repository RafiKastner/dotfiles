local icons = require("../icons")

local floaters = {}

sbar.exec("echo", function(_) --to make it appear after menus & spaces
	local fullscreen = sbar.add("item", "fullscreen", {
		icon = " ",
		updates = true,
	})

	fullscreen:subscribe("aerospace_floating", function()
		sbar.exec("aerospace list-windows --format %{app-name} --focused", function(text)
			if floaters[text] == nil then
				floaters[text] = false
			end
			floaters[text] = not floaters[text]
			fullscreen:set({
				icon = floaters[text] and icons.life_preserve or "",
			})
		end)
	end)

	fullscreen:subscribe("focus_changed", function()
		sbar.exec("aerospace list-windows --format %{app-name} --focused", function(text)
			if floaters[text] == nil then
				floaters[text] = false
			end
			fullscreen:set({
				icon = floaters[text] and icons.life_preserve or "",
			})
		end)
	end)
end)
