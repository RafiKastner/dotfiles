local colors = require("colors")
local settings = require("settings")

sbar.bar({
	topmost = "window",
	height = settings.height,
	color = colors.bar.bg,
	blur_radius = 20,
	sticky = true,
	font_smoothing = true,
	padding_right = 2,
	padding_left = 2,
	corner_radius = 10,
	margin = 3,
	y_offset = 3,
})
