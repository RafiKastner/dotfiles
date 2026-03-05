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
	update_freq = 60,
	popup = {
		align = "center",
		background = {
			corner_radius = settings.corner_radius,
			color = colors.bg0,
		},
	},
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
battery:subscribe({ "routine", "power_source_change", "system_woke" }, function()
	sbar.exec("pmset -g batt", function(info)
		local found, _, charge = info:find("(%d+)%%")
		if found then
			charge = tonumber(charge)
		else
			charge = 0
		end

		local charging_symbol = info:find("AC Power") and "󱐋" or ""
		local fill = math.floor(charge / (100 / MAX_LENGTH))

		battery:set({
			icon = {
				string = "[" .. string.rep("|", fill),
				color = charge < 20 and colors.red or colors.green,
			},
			label = {
				string = string.rep("|", MAX_LENGTH - fill - 1) .. "]",
				color = charge > 100 - (100 / MAX_LENGTH) and colors.green or colors.white,
			},
		})
		percent:set({
			icon = {
				string = charging_symbol .. (charge < 10 and "0" or "") .. tostring(charge) .. "%",
				color = charge < 10 and colors.red or colors.white,
			},
		})
	end)
end)

local FONT_RESET = {
	family = settings.font_system,
	size = settings.sizes.icon - 2,
	style = "Normal",
}

local popup_header = sbar.add("item", "battery.popup.header", {
	position = "popup." .. battery.name,
	topmost = true,
	y_offset = -6,
	icon = {
		string = "Battery",
		font = helpers.TableConcat(FONT_RESET, {
			style = "Bold",
		}),
	},
})

local popup_info = sbar.add("item", "battery.popup.info", {
	position = "popup." .. battery.name,
	icon = {
		font = FONT_RESET,
	},
})

battery:subscribe("mouse.clicked", function()
	sbar.exec("pmset -g batt", function(info)
		local charging = info:find("AC Power") or false
		local remaining = info:match("%d*:%d%d remaining") or "(no estimate)"
		if charging then
			remaining = remaining .. " until full charge"
		end

		battery:set({
			popup = {
				drawing = "toggle",
			},
		})
		popup_info:set({
			icon = {
				string = tostring(remaining),
			},
		})
	end)
end)
