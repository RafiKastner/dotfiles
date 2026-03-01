local frames = {
	"^~~-=#&8|",
	"~===&#89|",
	"__=&##89|",
	"=_&#==89|",
	"^&*=--89|",
	"#*^=-#99|",
	"*^--==9&|",
}

local flag = sbar.add("item", "flag", {
	position = "right",
})
sbar.exec("killall flag >/dev/null; $CONFIG_DIR/helpers/event_providers/animate_flag/flag")
