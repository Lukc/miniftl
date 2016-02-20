
yui = require ".yui.init"
SDL = require "SDL"

RoomButton = (room, parent) ->
	{:x, :y} = room.position
	rect =
		x: x,
		y: y,
		w: room.width,
		h: room.height

	if parent.rotated
		rect.x, rect.y = rect.y, rect.x
		rect.w, rect.h = rect.h, rect.w

	yui.Button {
		x: rect.x * 48,
		y: rect.y * 48,
		width: 48 * rect.w,
		height: 48 * rect.h,

		events:
			click: (button) =>
				if button == 1 -- left
					if parent.selection.type == "weapon"
						weapon = parent.selection.weapon

						weapon.target = {
							room: room,
							ship: parent.ship
						}

					parent.selection.type = "none"

		theme:
			drawButton: (renderer) =>
				if room.system
					renderer\setDrawColor 0x88FF88
				else
					renderer\setDrawColor 0x888888

				renderer\drawRect @rectangle!
	}

DoorButton = (door, parent) ->
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

	if parent.rotated
		rect.x, rect.y = rect.y, rect.x
		rect.w, rect.h = rect.h, rect.w

	rect.x += parent.realX
	rect.y += parent.realY

	yui.Button {
		x: rect.x,
		y: rect.y,
		width: rect.w,
		height: rect.h,
		events:
			click: (button) =>
				unless parent.controlable
					return false

				if button == 1
					door.opened = not door.opened
		theme:
			drawButton: (renderer) =>
				renderer\setDrawColor 0x000000
				renderer\fillRect self\rectangle!

				if @hovered and parent.controlable
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

ShipView =
	new: (opts) =>
		yui.Widget.new self, opts

		unless opts.ship
			error "no opts.ship!"

		self.ship = opts.ship
		self.rotated = opts.rotated or false
		self.controlable = opts.controlable or false

		unless opts.selection
			print "WARNING: no .selection in parameters!"

		@selection = opts.selection

		for room in *@ship.rooms
			self\addChild (RoomButton room, self)

		for door in *@ship.doors
			self\addChild (DoorButton door, self)

	draw: (renderer) =>
		renderer\setDrawColor 0xFF8800
		renderer\drawRect @rectangle!

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

