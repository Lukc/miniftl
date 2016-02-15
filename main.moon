
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
	\addSystem (System!), test.rooms[2]
	\addSystem (System!), test.rooms[4]

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

