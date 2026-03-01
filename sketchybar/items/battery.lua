local colors = require("../colors")
local settings = require("../settings")
local icons = require("../icons")
local helpers = require("../helpers/functions/helper_funcs")

STYLE = {
	font = {
		family = settings.font_system,
		style = "Semibold",
		size = settings.sizes.icon,
	},
}

local percent = sbar.add("alias", "battery_percent", {
	position = "right",
	icon = STYLE,
})

local battery = sbar.add("item", "battery", {
	position = "right",
	y_offset = -1,
	icon = helpers.TableConcat({ padding_right = 1 }, STYLE), --percent filled
	label = helpers.TableConcat({ padding_left = 0 }, STYLE), --unfilled
	update_freq = 120,
	popup = { align = "center" },
})

local bracket = sbar.add("bracket", "battery_bracket", { "battery", "battery_percent" }, {
	background = {
		color = colors.transparent,
		border_width = 2,
		border_color = colors.blue,
		corner_radius = settings.corner_radius,
	},
})

MAX_LENGTH = 25
percent:subscribe({ "routine", "power_source_change", "system_woke" }, function()
	sbar.exec("pmset -g batt", function(info)
		local found, _, charge = info:find("(%d+)%%")
		if found then
			charge = tonumber(charge)
		else
			charge = 0
		end

		local fill = math.floor(charge / (100 / MAX_LENGTH))

		battery:set({
			icon = {
				string = "[" .. string.rep("|", fill),
				color = charge < 20 and colors.red or colors.green,
			},
			label = {
				string = string.rep("|", MAX_LENGTH - fill) .. "]",
			},
		})
		percent:set({
			icon = {
				string = (charge < 10 and "0" or "") .. tostring(charge) .. "%",
				color = charge < 10 and colors.red or colors.white,
			},
		})
	end)
end)
