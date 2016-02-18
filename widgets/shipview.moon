
yui = require ".yui.init"
SDL = require "SDL"

ShipView =
	new: (opts) =>
		yui.Widget.new self, opts

		unless opts.ship
			error "no opts.ship!"

		self.ship = opts.ship
		self.rotated = opts.rotated or false

		for door in *@ship.doors
			{:x, :y} = door.position

			local rect
			if door.type == "horizontal"
				rect =
					x: x * 48 + 8,
					y: (y + 1) * 48 - 6,
					w: 48 - 2 * 8,
					h: 12
			else
				rect =
					x: (x + 1) * 48 - 6,
					y: y * 48 + 8,
					w: 12,
					h: 48 - 2 * 8

			if @rotated
				rect.x, rect.y = rect.y, rect.x
				rect.w, rect.h = rect.h, rect.w

			rect.x += @realX
			rect.y += @realY

			yui.Widget.addChild self, yui.Button {
				x: rect.x,
				y: rect.y,
				width: rect.w,
				height: rect.h,
				events:
					click: (button) =>
						if button == 1
							door.opened = not door.opened
				theme:
					drawButton: (renderer) =>
						renderer\setDrawColor 0x000000
						renderer\fillRect self\rectangle!

						if @hovered
							if door.opened
								renderer\setDrawColor 0xFF8888
							else
								renderer\setDrawColor 0xBBBBBB
						else
							if door.opened
								renderer\setDrawColor 0xFF0000
							else
								renderer\setDrawColor 0x888888

						renderer\drawRect self\rectangle!
			}

	draw: (renderer) =>
		renderer\setDrawColor 0xFF8800
		renderer\drawRect @rectangle!

		for room in *@ship.rooms
			{:x, :y} = room.position

			rect =
				x: x * 48,
				y: y * 48,
				w: 48 * room.width,
				h: 48 * room.height

			if @rotated
				rect.x, rect.y = rect.y, rect.x
				rect.w, rect.h = rect.h, rect.w

			rect.x += @realX
			rect.y += @realY

			if room.system
				renderer\setDrawColor 0x00FFFF
			else
				renderer\setDrawColor 0xFFFFFF

			renderer\drawRect rect

		for crew in *@ship.crew
			rect = {
				x: crew.position.x * 48 + 8,
				y: crew.position.y * 48 + 8,
				w: 32,
				h: 32
			}

			if @rotated
				rect.x, rect.y = rect.y, rect.x
				rect.w, rect.h = rect.h, rect.w

			rect.x += @realX
			rect.y += @realY

			renderer\setDrawColor 0x00FF88
			renderer\drawRect rect

		yui.Widget.draw self, renderer

yui.Object ShipView, yui.Widget

