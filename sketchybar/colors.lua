--Catppuccin Frappé theme
local palette = require("catppuccin.frappe")
local helpers = require("./helpers/functions/helper_funcs")

local colors = {}

for color, v in pairs(palette) do
	local hex, _ = tostring(v.hex):gsub("#", "0xff")
	if hex ~= nil then
		colors[color] = hex
	end
end

local ret = helpers.TableConcat({
	transparent = 0x00000000,
	white = 0xfff2f0ef,

	bar = {
		bg = 0xd01e1e2e,
		border = 0xff494d64,
	},
	popup = {
		bg = 0xff1e1e2e,
		border = 0xffcad3f5,
	},
	bg0 = colors.mantle,
	bg1 = colors.base,
}, colors)

return ret
