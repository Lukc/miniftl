
yui = require ".yui.init"
SDL = require "SDL"

Ship = require "ship"
Room = require "room"
System = require "system"

test = Ship!

with test
	\addRoom (Room 2, 2), {x: 1, y: 1}
	\addRoom (Room 2, 1), {x: 3, y: 1}
	\addRoom (Room 1, 2), {x: 1, y: 3}
	\addRoom (Room 2, 2), {x: 1, y: 5}
	\addRoom (Room 2, 1), {x: 5, y: 1}

	\addDoor {x: 2, y: 1}, "vertical"
	\addDoor {x: 4, y: 1}, "vertical"
	\addDoor {x: 1, y: 2}, "horizontal"
	\addDoor {x: 1, y: 4}, "horizontal"

	\addSystem (System "Engines"), test.rooms[1]
	\addSystem (System "Weapons"), test.rooms[2]
	\addSystem (System "Shields"), test.rooms[4]
	\addSystem (System "Life Support"), test.rooms[5]

	\finalize!

for room in *test.rooms
	print room

	if room.system
		print "", room.system

buffer = [{} for i = 1, 24]
for j = 1, 24
	for i = 1, 80
		buffer[j][i] = " "

color = 0
for room in *test.rooms
	color = (color + 1) % 8
	x = room.position.x
	y = room.position.y
	for i = x, x + room.width - 1
		for j = y, y + room.height - 1
			char = "#"
			if room.system
				char = string.sub room.system.name, 1, 1

			buffer[j * 2][i * 2] = "\027[3#{color}m#{char}\027[00m"

			buffer[j * 2 - 1][i * 2] = "-"
			buffer[j * 2 + 1][i * 2] = "-"

			buffer[j * 2][i * 2 - 1] = "|"
			buffer[j * 2][i * 2 + 1] = "|"

for door in *test.doors
	x = door.position.x
	y = door.position.y

	if door.type == "vertical"
		buffer[y * 2][x * 2 + 1] = " "
	elseif door.type == "horizontal"
		buffer[y * 2 + 1][x * 2] = " "

for line in *buffer
	for char in *line
		io.write char
	io.write "\n"

yui.init!

yui\loadFont "default", "DejaVuSans.ttf", 18

w = yui.Window {
	width:  1280,
	height: 1024,
	flags: {SDL.window.Resizable},

	events:
		draw: (renderer) =>
			for room in *test.rooms
				{:x, :y} = room.position

				rect = {
					x: 400 + x * 48,
					y: 300 + y * 48,
					w: 48 * room.width,
					h: 48 * room.height
				}

				renderer\setDrawColor 0xFFFFFF
				renderer\drawRect rect

	yui.Column {
		yui.Frame {
			height: 300,
			events:
				update: (dt) =>
					root = self\getRoot!
					self.realWidth = root.width
		},
		yui.Row {
			width: 400,
			events:
				update: (dt) =>
					root = self\getRoot!
					self.realHeight = root.height - 600

			yui.Column {
				width: 400,

				events:
					update: (dt) =>
						self.realWidth = self.parent.realWidth

				yui.Button {
					height: 200
				}
			}
		},
		yui.Row {
			height: 300,
			events:
				update: (dt) =>
					if #@children == 0
						for system in *test.systems
							self\addChild yui.Frame {
								width: 80,
								events:
									update: (dt) =>
										--self.y = self.parent.height - self.realHeight
										self.realHeight = self.parent.height

								yui.Label {
									text: system.name
								}
							}
		}
	}
}

c = true
while c do
	c = yui\run {w}

