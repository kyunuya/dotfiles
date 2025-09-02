local colors = require("styles.colors")

local paddings = 10
local space_paddings = 8
local font = "JetBrainsMono Nerd Font"

return {
	spacing = {
		paddings = paddings,
	},

	defaults = {
		bar = {
			color = colors.transparent,
			position = "top",
			topmost = "off",
			sticky = "on",
			height = 37,
			padding_left = paddings,
			padding_right = paddings,
			corner_radius = 0,
			blur_radius = 0,
			notch_width = 160,
		},

		space = {
			position = "left",
			drawing = false,
			background = { height = 2 },
			label = {
				font = "sketchybar-app-font:Regular:14.0",
				padding_left = 0,
				padding_right = space_paddings,
				color = colors.white_50,
				highlight_color = colors.highlight,
				y_offset = -1,
			},
			icon = {
				color = colors.label_color,
				padding_left = 0,
				padding_right = 0,
				highlight_color = colors.highlight,
			},
			padding_left = space_paddings / 2,
			padding_right = space_paddings,
			updates = true,
		},

		front_app = {
			icon = {
				string = "􀆊",
				color = colors.flamingo,
				padding_left = 0,
				background = { image = { scale = 0.5 } },
			},
			label = {
				padding_right = paddings,
				color = colors.flamingo,
				font = { style = "Bold" },
			},
			padding_left = 0,
		},

		item = {
			background = {
				color = colors.transparent,
				padding_left = paddings / 2,
				padding_right = paddings / 2,
			},
			icon = {
				background = {
					corner_radius = 4,
					height = 18,
				},
				padding_left = 2,
				padding_right = paddings / 2,
				font = font .. ":Regular:12",
				color = colors.icon_color,
				highlight_color = colors.highlight,
			},
			label = {
				font = font .. ":Regular:12",
				color = colors.label_color,
				highlight_color = colors.highlight,
				padding_left = paddings / 2,
			},
			updates = "when_shown",
			scroll_texts = "on",
		},

		icon = { label = { drawing = false } },

		notification = {
			background = {
				color = colors.white_25,
				height = 16,
				corner_radius = 16,
			},
			icon = {
				font = { size = 10 },
				padding_left = paddings,
				padding_right = 0,
				color = colors.black_75,
			},
			label = {
				color = colors.black_75,
				padding_right = paddings,
				font = {
					size = 11,
					style = "Bold",
				},
			},
			drawing = false,
			update_freq = 120,
			updates = "on",
		},

		bracket = {
			background = {
				height = 33,
				color = colors.bar_color,
				corner_radius = paddings,
			},
			blur_radius = 32,
		},

		menu = {
			popup = {
				blur_radius = 32,
				background = {
					shadow = { drawing = true },
					color = colors.bar_color,
					corner_radius = paddings,
					border_width = 1,
					border_color = colors.grey_50,
				},
			},
		},

		menu_item = {
			background = { color = colors.transparent },
			label = { font = font .. ":Regular:13" },
			icon = {
				padding_left = 0,
				padding_right = paddings / 2,
				color = colors.highlight,
			},
			padding_left = paddings,
			padding_right = paddings,
		},
	},

	separator = {
		background = {
			height = 1,
			color = colors.white_25,
			y_offset = -16,
		},
		width = 200,
	},

	font = font,
}
