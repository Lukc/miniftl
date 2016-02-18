
yui = require ".yui.init"
SDL = require "SDL"

CrewView =
	new: (opts) =>
		unless opts.height
			opts.height = 52

		yui.Widget.new self, opts

		unless opts.crew
			error "no opts.crew!"

		@crew = opts.crew

		yui.Widget.addChild self, yui.Label {
			text: tostring @crew.name,
			x: 50
		}

	draw: (renderer) =>
		yui.Widget.draw self, renderer

		renderer\setDrawColor 0xFFFFFF
		renderer\drawRect @rectangle!

		renderer\setDrawColor 0x44FF88
		renderer\fillRect
			x: @realX + 50,
			y: @realY + 25,
			w: @crew.health / @crew.maxHealth * (@realWidth - 50 - 10),
			h: 10
			
yui.Object CrewView, yui.Widget

