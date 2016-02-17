
--yui = require ".yui.init"
--SDL = require "SDL"

Ship = require "ship"
Room = require "room"
System = require "system"

test = Ship!

with test
	\addRoom (Room 2, 1), {x: 1, y: 1}
	\addRoom (Room 2, 1), {x: 3, y: 1}
	\addRoom (Room 2, 2), {x: 3, y: 3}
	\addRoom (Room 2, 1), {x: 3, y: 6}
	\addRoom (Room 2, 1), {x: 1, y: 6}
	\addRoom (Room 2, 2), {x: 5, y: 3}
	\addRoom (Room 2, 1), {x: 4, y: 2}
	\addRoom (Room 2, 1), {x: 4, y: 5}
	\addRoom (Room 1, 2), {x: 7, y: 3}
	\addRoom (Room 2, 1), {x: 7, y: 2}
	\addRoom (Room 2, 1), {x: 7, y: 5}
	\addRoom (Room 1, 2), {x: 9, y: 2}
	\addRoom (Room 1, 2), {x: 9, y: 4}
	\addRoom (Room 2, 2), {x: 10, y: 3}

	\addDoor {x: 2, y: 1}, "horizontal"
	\addDoor {x: 3, y: 2}, "horizontal"

	\addDoor {x: 2, y: 1}, "vertical"
	\addDoor {x: 2, y: 6}, "vertical"

	\addDoor {x: 4, y: 1}, "horizontal"
	\addDoor {x: 4, y: 5}, "horizontal"

	\addDoor {x: 4, y: 3}, "vertical"
	\addDoor {x: 4, y: 4}, "vertical"
	\addDoor {x: 6, y: 3}, "vertical"
	\addDoor {x: 6, y: 4}, "vertical"

	\addDoor {x: 3, y: 4}, "horizontal"
	\addDoor {x: 2, y: 5}, "horizontal"

	\addDoor {x: 3, y: 2}, "vertical"
	\addDoor {x: 3, y: 5}, "vertical"

	\addDoor {x: 5, y: 2}, "horizontal"
	\addDoor {x: 5, y: 4}, "horizontal"

	\addSystem (System "Engines"), test.rooms[1], 3
	\addSystem (System "Weapons"), test.rooms[2], 2
	\addSystem (System "Shields"), test.rooms[4], 2
	\addSystem (System "Life Support"), test.rooms[5], 1

	\finalize!

for room in *test.rooms
	print room

	if room.system
		print "", room.system

buffer = [{} for i = 1, 24]
for j = 1, 24
	for i = 1, 80
		buffer[j][i] = " "

for j = 1, test.tiles.height
	for i = 1, test.tiles.width
		tile = test.tiles[i][j]
		if tile
			buffer[j*2-1][i*2] = "-"
			buffer[j*2+1][i*2] = "-"
			buffer[j*2][i*2+1] = "|"
			buffer[j*2][i*2-1] = "|"
			buffer[j*2][i*2] = "0"
			for h = 1, 4
				if tile.links[h]
					if tile.links[h].direction == "up"
						if tile.links[h].door
							buffer[j*2-1][i*2] = "~"
						else
							buffer[j*2-1][i*2] = " "
					elseif tile.links[h].direction == "right"
						if tile.links[h].door
							buffer[j*2][i*2+1] = "/"
						else
							buffer[j*2][i*2+1] = " "
					elseif tile.links[h].direction == "down"
						if tile.links[h].door
							buffer[j*2+1][i*2] = "~"
						else
							buffer[j*2+1][i*2] = " "
					elseif tile.links[h].direction == "left"
						if tile.links[h].door
							buffer[j*2][i*2-1] = "/"
						else
							buffer[j*2][i*2-1] = " "

for line in *buffer
	for char in *line
		io.write char
	io.write "\n"

ShipView =
	new: (opts) =>
		yui.Widget.new self, opts

		unless opts.ship
			error "no opts.ship!"

		self.ship = opts.ship

	draw: (renderer) =>
		for room in *@ship.rooms
			{:x, :y} = room.position

			rect = {
				x: self.realX + x * 48,
				y: self.realY + y * 48,
				w: 48 * room.width,
				h: 48 * room.height
			}

			if room.system
				renderer\setDrawColor 0x00FFFF
			else
				renderer\setDrawColor 0xFFFFFF

			renderer\drawRect rect

		for door in *@ship.doors
			{:x, :y} = door.position

			local rect
			if door.type == "horizontal"
				rect =
					x: self.realX + x * 48 + 8,
					y: self.realY + (y + 1) * 48 - 6,
					w: 48 - 2 * 8,
					h: 12
			else
				rect =
					x: self.realX + (x + 1) * 48 - 6,
					y: self.realY + y * 48 + 8,
					w: 12,
					h: 48 - 2 * 8

			renderer\setDrawColor 0x888888
			renderer\drawRect rect

		renderer\setDrawColor 0xFF8800
		renderer\drawRect (self\rectangle!)

ShipView = yui.Object ShipView, yui.Widget

yui.init!

yui\loadFont "default", "DejaVuSans.ttf", 18

w = yui.Window {
	width:  1280,
	height: 1024,
	flags: {SDL.window.Resizable},

	ShipView {
		x: 160,
		y: 300,
		width: 600,
		height: 400,
		ship: test
	},

	ShipView {
		x: 760,
		y: 300,
		width: 600,
		height: 400,
		ship: test
	},

	yui.Column {
		yui.Frame {
			height: 300,
			events:
				update: (dt) =>
					root = self\getRoot!
					self.realWidth = root.width
		},
		yui.Row {
			width: 160,
			events:
				update: (dt) =>
					root = self\getRoot!
					self.realHeight = root.height - 600

			yui.Column {
				width: 160,

				events:
					update: (dt) =>
						self.realWidth = self.parent.realWidth

				unpack [(yui.Button {
					height: 52
				}) for i = 1, 8]
			}
		},
		yui.Row {
			height: 300,
			events:
				update: (dt) =>
					if #@children == 0
						frame = yui.Frame {
							width: 100,
							events:
								update: (dt) =>
									--self.y = self.parent.height - self.realHeight
									self.realHeight = self.parent.height
						}

						self\addChild frame

						for i = 1, test.power
							frame\addChild yui.Button {
								width: 60,
								height: 10,
								x: 10,
								y: frame.parent.height - 72 - 5 - i * 15
							}

						for system in *test.systems
							frame = yui.Frame {
								width: 80,
								events:
									update: (dt) =>
										--self.y = self.parent.height - self.realHeight
										self.realHeight = self.parent.height

								yui.Label {
									text: system.name
								}
							}

							self\addChild frame

							for i = 1, system.level
								frame\addChild yui.Button {
									width: 60,
									height: 10,
									x: 10,
									y: frame.parent.height - 72 - 5 - i * 15
								}
		}
	}
}

c = true
while c do
	c = yui\run {w}

