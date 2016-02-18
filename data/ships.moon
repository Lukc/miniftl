
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
}

