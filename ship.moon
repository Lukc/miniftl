
Room = require "room"

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

	addRoom: (room, to) =>
		@rooms[#@rooms+1] = room

		room.position = to

	addDoor: (position, type) =>
		@doors[#@doors+1] = {
			position: position,
			type: type
		}

	addSystem: (system, room) =>
		@systems[#@systems+1] = system

		system.room = room
		room.system = system

	finalize: () =>
		@tiles = {}

