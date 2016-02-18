
yui = require ".yui.init"
SDL = require "SDL"

return (ship) ->
	frame = yui.Frame {
		width: 70,
		events:
			update: (dt) =>
				--self.y = self.parent.height - self.realHeight
				self.realHeight = self.parent.height
	}

	for i = 1, ship.reactorLevel
		frame\addChild yui.Button {
			width: 40,
			height: 5,
			x: 10,
			y: 276 - 48 - 7 - i * 8,
			theme:
				drawButton: (renderer) =>
					totalPower = 0
					for system in *ship.systems
						totalPower += system.power

					if ship.reactorLevel - totalPower >= i
						renderer\setDrawColor 0x00FF00
					else
						renderer\setDrawColor 0xFF8800

					renderer\fillRect self\rectangle!
		}

	frame

