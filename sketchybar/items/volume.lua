local settings = require("../settings")
local colors = require("../colors")

local volume = sbar.add("alias", "Control Center,Sound", {
	position = "right",
	background = {
		color = colors.transparent,
		border_width = 2,
		border_color = colors.lavender,
		corner_radius = settings.corner_radius,
	},
})
