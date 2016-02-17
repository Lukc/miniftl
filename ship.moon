
Room = require "room"
Tile = require "tile"

class
	new: (name = "") =>
		@name = name

		@scrap    = 0
		@missiles = 0
		@fuel     = 0
		@parts    = 0

		@rooms   = {}
		@doors   = {}
		@systems = {}
		@crew    = {}

		-- Sane default value.
		@power   = 8

		@maxHealth = 30
		@health    = 30

	addRoom: (room, to) =>
		@rooms[#@rooms+1] = room

		room.position = to

	addDoor: (position, type) =>
		@doors[#@doors+1] = {
			position: position,
			type: type
		}

	addSystem: (system, room, level) =>
		system = system\clone!

		@systems[#@systems+1] = system

		system.room = room
		room.system = system

		if level
			system.level = level

	addCrew: (crew, position) =>
		@crew[#@crew+1] = crew
		crew.position = position

	finalize: () =>
		width = 1
		height = 1
		@tiles = {}
		for room in *@rooms
			for j = 0,room.height-1
				height = height +1
				for i = 0,room.width-1
					x = room.position.x + i
					y = room.position.y + j
					tempTile = Tile x, y
					unless @tiles[x]
						@tiles[x] = {}
					@tiles[x][y] = tempTile
					if x > width
						width = x
					
					unless x == room.position.x
						@tiles[x][y]\addLink @tiles[x-1][y], nil, "left"
					
					unless y == room.position.y
						@tiles[x][y]\addLink @tiles[x][y-1], nil, "up"
		@tiles.width = width
		@tiles.height = height

		for door in *@doors
			tile = @tiles[door.position.x][door.position.y]

			if door.type == "vertical" and tile
				tile\addLink @tiles[door.position.x+1][door.position.y], door, "right"

			if door.type == "horizontal" and tile
				tile\addLink @tiles[door.position.x][door.position.y+1], door, "down"

