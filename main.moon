
yui = require ".yui.init"
SDL = require "SDL"

Ship = require "ship"
Room = require "room"
System = require "system"
CrewMan = require "crewman"
Weapon = require "weapon"

cli = require "cli"

-- Custom widgets.
ShipView = require "widgets.shipview"
CrewView = require "widgets.crewview"
SystemView = require "widgets.systemview"
ReactorView = require "widgets.reactorview"

-- Game data.
systems = require "data.systems"

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

	\addSystem systems.engines, test.rooms[1], 3
	\addSystem systems.weapons, test.rooms[2], 5
	\addSystem systems.shields, test.rooms[4], 4
	\addSystem systems.lifeSupport, test.rooms[5], 1

	\addCrew (CrewMan {}, "Luke"), {x: test.rooms[3].position.x, y: test.rooms[3].position.y}

	\addCrew (CrewMan {}, "Leia"), {x: test.rooms[4].position.x, y: test.rooms[4].position.y}

	.reactorLevel = 14

	\finalize!

	\addWeapon Weapon
		name: "Big Laser"
		power: 3
		shots: 3
	\addWeapon Weapon
		name: "Simple Laser"

for room in *test.rooms
	print room

	if room.system
		print "", room.system

cli.dump test

yui.init!

yui\loadFont "default", "DejaVuSans.ttf", 18

w = yui.Window {
	width:  1280,
	height: 800,
	--flags: {SDL.window.Resizable},

	theme:
		drawRow: (r) =>
			if @hovered
				r\setDrawColor 0xFFFFFF
			else
				r\setDrawColor 0x888888

			r\drawRect yui.growRectangle @rectangle!, 2

	ShipView {
		x: 160,
		y: 100,
		width: 600,
		height: 400,
		ship: test
	},

	ShipView {
		x: 760,
		y: 100,
		width: 400,
		height: 600,
		ship: test,
		rotated: true
	},

	yui.Column {
		-- Expected window size.
		width: 1280,
		--events:
		--	update: (dt) =>
		--		@realWidth = @parent.realWidth
		yui.Frame {
			height: 100,
			events:
				update: (dt) =>
					root = self\getRoot!
					self.realWidth = root.width
			yui.Frame {
				width: 12 * 32,
				height: 24 + 20 + 4,
				theme:
					drawFrame: (renderer) =>
						renderer\setDrawColor 0x44FF88

						renderer\drawRect @rectangle!

						for i = 1, test.maxHealth
							renderer\drawRect {
								x: i * 12,
								y: 24,
								w: 10,
								h: 20
							}
			}
		},
		yui.Row {
			width: 160,
			events:
				update: (dt) =>
					root = self\getRoot!
					self.realHeight = root.height - 376

			yui.Column {
				width: 160,

				events:
					update: (dt) =>
						self.realWidth = self.parent.realWidth

				unpack [(CrewView crew: crew) for crew in *test.crew]
			}
		},
		yui.Row {
			height: 276,
			events:
				update: (dt) =>
					if #@children == 0
						self\addChild ReactorView test

						for system in *test.systems
							self\addChild SystemView system, test, frame
		}
	},
	yui.Frame {
		width: 400,
		height: 100,
		x: 1280 - 400 * 2 - 20 * 2,
		y: 800 - 100 - 20,

		events:
			update: (dt) =>
				if #@children == 0
					offset = 0
					for weapon in *test.weapons
						self\addChild yui.Frame {
							width: 130,
							height: 100,
							x: offset,

							events:
								click: (button) =>
									if weapon.powered
										weapon.powered = false

										for system in *test.systems
											if system.name == "Weapons"
												system.power -= weapon.power
												return
									else
										powerUsed = 0
										for system in *test.systems
											powerUsed += system.power

										if powerUsed + weapon.power <= test.reactorLevel
											weapon.powered = true

											for system in *test.systems
												if system.name == "Weapons"
													system.power += weapon.power
													return
										else
											print "Not enough power!"

							yui.Label weapon.name
						}

						offset += 133
	},
	yui.Frame {
		width: 400,
		height: 100,
		x: 1280 - 400 - 20,
		y: 800 - 100 - 20
	}
}

testPosition =
	x: 8
	y: 3
trajectory = test.crew[2]\pathfinding test.dijkstra, testPosition, test.tiles
if trajectory
	for traj in *trajectory
		print traj.direction .. " " .. traj.tile.position.x .. " " .. traj.tile.position.y
else print "Destination unreachable"

c = true
while c do
	c = yui\run {w}

