local icons = require("../icons")

local floaters = {}

sbar.exec("echo", function(_) --to make it appear after menus & spaces
	local floating = sbar.add("item", "floating", {
		position = "right",
		updates = true,
	})

	floating:subscribe("aerospace_floating", function()
		sbar.exec("aerospace list-windows --format %{app-name} --focused", function(text)
			if floaters[text] == nil then
				floaters[text] = false
			end
			floaters[text] = not floaters[text]
			floating:set({
				icon = floaters[text] and icons.life_preserve or "",
			})
		end)
	end)

	floating:subscribe("focus_changed", function()
		sbar.exec("aerospace list-windows --format %{app-name} --focused", function(text)
			if floaters[text] == nil then
				floaters[text] = false
			end
			floating:set({
				icon = floaters[text] and icons.life_preserve or "",
			})
		end)
	end)
end)
