
Ship = require "ship"
Room = require "room"

systems = require "data.systems"

{
	raider: with Ship!
		\addRoom (Room 2, 1), {x: 1, y: 1}
		\addRoom (Room 2, 1), {x: 1, y: 4}

		\addRoom (Room 2, 1), {x: 2, y: 2}
		\addRoom (Room 2, 1), {x: 2, y: 3}

		\addRoom (Room 1, 2), {x: 4, y: 2}

		\addDoor {x: 2, y: 1}, "horizontal"
		\addDoor {x: 2, y: 2}, "horizontal"
		\addDoor {x: 2, y: 3}, "horizontal"

		\addDoor {x: 3, y: 2}, "vertical"
		\addDoor {x: 3, y: 3}, "vertical"

		\addSystem systems.weapons, .rooms[1], 2
		\addSystem systems.shields, .rooms[2], 2

		\addSystem systems.lifeSupport, .rooms[3], 1
		\addSystem systems.engines, .rooms[4], 1

		\addSystem systems.bridge, .rooms[5], 1

	raider2: with Ship!
		\addRoom (Room 2, 1), {x: 3, y: 1}
		\addRoom (Room 2, 1), {x: 3, y: 7}

		\addRoom (Room 1, 2), {x: 3, y: 2}
		\addRoom (Room 1, 2), {x: 3, y: 5}

		\addRoom (Room 2, 1), {x: 2, y: 4}

		\addRoom (Room 1, 2), {x: 5, y: 1}
		\addRoom (Room 1, 2), {x: 5, y: 6}

		\addDoor {x: 3, y: 1}, "horizontal"
		\addDoor {x: 3, y: 6}, "horizontal"

		\addDoor {x: 3, y: 3}, "horizontal"
		\addDoor {x: 3, y: 4}, "horizontal"

		\addDoor {x: 4, y: 1}, "vertical"
		\addDoor {x: 4, y: 7}, "vertical"

		\addDoor {x: 2, y: 3}, "vertical"
		\addDoor {x: 2, y: 5}, "vertical"

		\addSystem systems.weapons, .rooms[1], 3
		\addSystem systems.shields, .rooms[2], 8
		\addSystem systems.lifeSupport, .rooms[3], 3

		\addSystem systems.doorsControl, .rooms[4], 2
	cruiser1: with Ship!
		\addRoom (Room 2, 2), {x: 1, y: 1}
		\addRoom (Room 2, 1), {x: 3, y: 1}
		\addRoom (Room 2, 1), {x: 3, y: 2}
		\addRoom (Room 2, 1), {x: 5, y: 1}
		\addRoom (Room 2, 2), {x: 5, y: 2}
		\addRoom (Room 1, 2), {x: 7, y: 1}
		\addRoom (Room 1, 2), {x: 8, y: 2}

		\addRoom (Room 2, 2), {x: 4, y: 4}
		\addRoom (Room 1, 2), {x: 8, y: 4}

		\addRoom (Room 2, 2), {x: 5, y: 6}
		\addRoom (Room 2, 1), {x: 5, y: 8}
		\addRoom (Room 1, 2), {x: 8, y: 6}
		\addRoom (Room 1, 2), {x: 7, y: 7}
		\addRoom (Room 2, 2), {x: 1, y: 7}
		\addRoom (Room 2, 1), {x: 3, y: 7}
		\addRoom (Room 2, 1), {x: 3, y: 8}

		\addDoor {x: 2, y: 1}, "vertical"
		\addDoor {x: 2, y: 2}, "vertical"
		\addDoor {x: 2, y: 7}, "vertical"
		\addDoor {x: 2, y: 8}, "vertical"

		\addDoor {x: 4, y: 1}, "vertical"
		\addDoor {x: 4, y: 2}, "vertical"
		\addDoor {x: 4, y: 7}, "vertical"
		\addDoor {x: 4, y: 8}, "vertical"

		\addDoor {x: 6, y: 1}, "vertical"
		\addDoor {x: 6, y: 2}, "vertical"
		\addDoor {x: 6, y: 7}, "vertical"
		\addDoor {x: 6, y: 8}, "vertical"

		\addDoor {x: 7, y: 2}, "vertical"
		\addDoor {x: 7, y: 7}, "vertical"

		\addDoor {x: 5, y: 3}, "horizontal"
		\addDoor {x: 5, y: 5}, "horizontal"

		\addDoor {x: 8, y: 3}, "horizontal"
		\addDoor {x: 8, y: 5}, "horizontal"

		\addDoor {x: 1, y: 2}, "horizontal"
		\addDoor {x: 1, y: 6}, "horizontal"

		\addDoor {x: 3, y: 2}, "horizontal"
		\addDoor {x: 3, y: 6}, "horizontal"
		\addDoor {x: 4, y: 2}, "horizontal"
		\addDoor {x: 4, y: 6}, "horizontal"

		\addSystem systems.lifeSupport, .rooms[4], 1
		\addSystem systems.doorsControl, .rooms[11], 1

		\addSystem systems.weapons, .rooms[5], 4
		\addSystem systems.shields, .rooms[10], 2
		\addSystem systems.bridge, .rooms[8], 1

		\addSystem systems.engines, .rooms[1], 1
		\addSystem systems.engines, .rooms[14], 1

		\addSystem systems.teleporter, .rooms[2], 1
		\addSystem systems.drones, .rooms[16], 1

		.reactorLevel = 12
}

