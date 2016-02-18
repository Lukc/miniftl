
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

		@shieldsProgress = 0
		@shields = 0

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

	getMaxShields: =>
		for system in *@systems
			if system.special == "shields"
				return (system.power - system.power % 2) / 2

		return 0

	finalize: () =>
		width = 1
		height = 1
		@tiles = {}
		@dijkstra = {}
		for room in *@rooms
			for j = 0,room.height-1
				height = height +1
				for i = 0,room.width-1
					x = room.position.x + i
					y = room.position.y + j
					tempTile = Tile x, y
					tempTile.posInDijkstra = #@dijkstra+1
					unless @tiles[x]
						@tiles[x] = {}
					@tiles[x][y] = tempTile
					@dijkstra[#@dijkstra+1] = tempTile
					@dijkstra[#@dijkstra].weight = math.huge
					@dijkstra[#@dijkstra].goTo
					@dijkstra[#@dijkstra].process = false
					if x > width
						width = x
					
					unless x == room.position.x
						@tiles[x][y]\addLink @tiles[x-1][y], nil, "left"
						@dijkstra[@tiles[x][y].posInDijkstra]\addLink @dijkstra[@tiles[x-1][y].posInDijkstra], nil, "left"
					
					unless y == room.position.y
						@tiles[x][y]\addLink @tiles[x][y-1], nil, "up"
						@dijkstra[@tiles[x][y].posInDijkstra]\addLink @dijkstra[@tiles[x][y-1].posInDijkstra], nil, "up"

		@tiles.width = width
		@tiles.height = height

		for door in *@doors
			tile = @tiles[door.position.x][door.position.y]

			if door.type == "vertical" and tile
				tile\addLink @tiles[door.position.x+1][door.position.y], door, "right"
				if @tiles[door.position.x+1][door.position.y]
					@dijkstra[tile.posInDijkstra]\addLink @dijkstra[@tiles[door.position.x+1][door.position.y].posInDijkstra], door, "right"
			if door.type == "horizontal" and tile
				tile\addLink @tiles[door.position.x][door.position.y+1], door, "down"
				if @tiles[door.position.x][door.position.y+1]
					@dijkstra[tile.posInDijkstra]\addLink @dijkstra[@tiles[door.position.x][door.position.y+1].posInDijkstra], door, "down"

	update: (dt) =>
		maxShields = self\getMaxShields!

		if @shields == maxShields
			return

		if @shields > maxShields
			@shields = maxShields
			return

		@shieldsProgress += dt

		if @shieldsProgress >= @@shieldsChargeTime
			@shields += 1

			if @shields < maxShields
				@shieldsProgress -= @@shieldsChargeTime
			else
				@shieldsProgress = 0

	shieldsChargeTime: 2000

