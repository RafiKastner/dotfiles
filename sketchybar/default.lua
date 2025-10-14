local settings = require("settings")
local colors = require("colors")

-- Equivalent to the --default domain
sbar.default({
	updates = "when_shown",
	icon = {
		font = {
			family = settings.font,
			style = "Bold",
			size = settings.sizes.icon,
		},
		color = colors.white,
		padding_left = settings.paddings,
		padding_right = settings.paddings,
		background = { image = { corner_radius = 9 } },
	},
	label = {
		font = {
			family = settings.font,
			style = "Semibold",
			size = settings.sizes.label,
		},
		color = colors.white,
		padding_left = settings.paddings,
		padding_right = settings.paddings,
	},
	background = {
		height = settings.height * settings.ratios.bg,
		corner_radius = settings.height * 1 / 4,
		border_width = 2,
		border_color = colors.bg2,
		image = {
			corner_radius = 9,
			border_color = colors.grey,
			border_width = 1,
		},
	},
	popup = {
		background = {
			border_width = 2,
			corner_radius = 9,
			border_color = colors.popup.border,
			color = colors.popup.bg,
			shadow = { drawing = true },
		},
		blur_radius = 50,
	},
	padding_left = 5,
	padding_right = 5,
	scroll_texts = true,
})
