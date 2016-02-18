
yui = require ".yui.init"
SDL = require "SDL"

-- FIXME: Make it a true widget? Maybe?
return (system, ship) ->
	frame = yui.Frame {
		width: 60,
		height: 276,
		events:
			update: (dt) =>
				--self.y = self.parent.height - self.realHeight
				self.realHeight = self.parent.height

		yui.Label {
			text: system.name
		},
		yui.Button
			width: 48,
			height: 48,
			x: 5,
			y: 276 - 48 - 5,
			events:
				click: (click) =>
					if click == 1
						ship\power system
					elseif click == 3
						ship\unpower system
	}

	for i = 1, system.level
		frame\addChild yui.Button {
			width: 40,
			height: 5,
			x: 10,
			y: 276 - 48 - 7 - i * 8,
			theme:
				drawButton: (renderer) =>
					if system.power >= i
						renderer\setDrawColor 0x00FF00
					else
						renderer\setDrawColor 0xFF8800

					renderer\fillRect @rectangle!
		}

	frame

