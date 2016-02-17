
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
		@weapons = {}

		-- Sane default value.
		@reactorLevel = 8

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

	addWeapon: (weapon) =>
		@weapons[#@weapons+1] = weapon

	power: (system) =>
		powerUsed = 0
		for sys in *@systems
			powerUsed += sys.power

		if system.powerMethod
			system\powerMethod self, powerUsed
		else
			if system.power < system.level and powerUsed < @reactorLevel
				system.power += 1

				true

	unpower: (system) =>
		if system.unpowerMethod
			system\unpowerMethod self
		else
			if system.power > 0
				system.power -= 1

				true

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
		
		@dijkstra = {}
		for i = 1, @tiles.width
			for j = 1, @tiles.height
				if @tiles[i][j]
					@tiles[i][j].posInDijkstra = #@dijkstra+1
					@dijkstra[#@dijkstra+1] = @tiles[i][j]
					@dijkstra[#@dijkstra].weight = math.huge
					@dijkstra[#@dijkstra].goTo
					@dijkstra[#@dijkstra].process = false
		for tile in *@dijkstra
			for link in *tile.links
				if link.tile
					link.tile = @dijkstra[link.tile.posInDijkstra]
