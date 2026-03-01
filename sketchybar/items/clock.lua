local colors = require("../colors")
local settings = require("../settings")

PADDING = 10

local clock = sbar.add("item", "clock", {
	position = "right",
	update_freq = "1",
	icon = {
		color = colors.white,
		font = {
			style = "Semibold",
			size = settings.sizes.label,
		},
		padding_left = PADDING,
	},
	label = {
		font = {
			style = "Semibold",
			size = settings.sizes.label,
		},
		color = colors.white,
		padding_right = PADDING,
	},
	background = {
		color = colors.transparent,
		border_color = colors.peach,
		border_width = 2,
		corner_radius = settings.corner_radius,
	},
})

clock:subscribe({ "forced", "routine", "system_woke" }, function()
	-- so no leading zero
	local function no_zero(str)
		if string.sub(str, 1, 1) == "0" then
			return string.sub(str, 2)
		end
		return str
	end
	local hour = no_zero(tostring(os.date("%I")))
	local day = tostring(os.date("%d")) --eh i like leading zero for day

	clock:set({ icon = os.date("%a %b ") .. day, label = hour .. ":" .. os.date("%M %p") })
end)
