
yui = require ".yui.init"
SDL = require "SDL"

Ship = require "ship"
Room = require "room"
System = require "system"
CrewMan = require "crewman"
Weapon = require "weapon"
Battle = require "battle"

cli = require "cli"

-- Custom widgets.
ShipView = require "widgets.shipview"
CrewView = require "widgets.crewview"
SystemView = require "widgets.systemview"
ReactorView = require "widgets.reactorview"

-- Game data.
systems = require "data.systems"
ships = require "data.ships"

battle = Battle!

player = Ship!

battle\addShip player, 1
battle\addShip ships.raider\clone!\finalize!, 1

battle\addShip ships.raider\clone!\finalize!, 2
battle\addShip ships.raider\clone!\finalize!, 2

with player
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

	\addSystem systems.engines, player.rooms[1], 3
	\addSystem systems.weapons, player.rooms[2], 5
	\addSystem systems.shields, player.rooms[4], 4
	\addSystem systems.lifeSupport, player.rooms[5], 1

	\addCrew (CrewMan {}, "Luke"), {x: player.rooms[3].position.x, y: player.rooms[3].position.y}

	\addCrew (CrewMan {}, "Leia"), {x: player.rooms[4].position.x, y: player.rooms[4].position.y}

	.reactorLevel = 14

	\finalize!

	\addWeapon Weapon
		name: "Big Laser"
		power: 3
		shots: 3
	\addWeapon Weapon
		name: "Simple Laser"

for room in *player.rooms
	print room

	if room.system
		print "", room.system

cli.dump player

yui.init!

yui\loadFont "default", "DejaVuSans.ttf", 18

w = yui.Window {
	width:  1280,
	height: 800,
	--flags: {SDL.window.Resizable},

	events:
		update: (dt) =>
			battle\update dt

	theme:
		drawRow: (r) =>
			if @hovered
				r\setDrawColor 0xFFFFFF
			else
				r\setDrawColor 0x888888

			r\drawRect yui.growRectangle @rectangle!, 2

	yui.Frame {
		x: 1280 - 2 - 8 * 32 - 2,
		y: 2,
		width: 2 + 8 * 32,
		height: 34,

		events:
			update: (dt) =>
				if #@children == 0
					for i = 1, #battle.ships
						ship = battle.ships[i]

						self\addChild yui.Button {
							x: 2 + 32 * (i - 1),
							y: 2,
							width: 30,
							height: 30,

							theme:
								drawButton: (renderer) =>
									fleet = battle\fleetOf ship
									if fleet == 1
										renderer\setDrawColor 0x8888FF
									elseif fleet == 2
										renderer\setDrawColor 0xFF8888
									else
										renderer\setDrawColor 0x888888

									renderer\drawRect @rectangle!

							events:
								click: (button) =>
									if button == 1
										view = self\getRoot!\getElementById "targetView"

										view\removeChild view.children[1]

										view\addChild ShipView
											width: view.realWidth,
											height: view.realHeight,
											ship: ship,
											rotated: true

							yui.Label
								text: ship.name
						}
	},

	ShipView {
		x: 160,
		y: 100,
		width: 600,
		height: 400,
		ship: player
	},

	yui.Frame {
		x: 760,
		y: 100,
		width: 400,
		height: 600,
		id: "targetView",

		ShipView {
			width: 400,
			height: 600,
			ship: battle.fleets[2][1],
			rotated: true,
		},
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

						for i = 1, player.maxHealth
							renderer\drawRect {
								x: i * 12,
								y: 24,
								w: 10,
								h: 20
							}
			},
			yui.Frame {
				x: 10,
				y: 51,
				width: 45 * 4,
				height: 43,
				theme:
					drawFrame: (renderer) =>
						maxShields = player\getMaxShields!

						renderer\setDrawColor 0x0088FF

						for i = 1, player.shields
							renderer\drawRect
								x: (i - 1) * 45,
								y: 53,
								w: 40,
								h: 40

						renderer\setDrawColor 0x004488

						for i = player.shields + 1, maxShields
							renderer\drawRect
								x: (i - 1) * 45,
								y: 53,
								w: 40,
								h: 40

						renderer\drawRect
							x: 5 * 45,
							y: 53,
							w: math.floor math.floor (player.shieldsProgress / Ship.shieldsChargeTime) * 120,
							h: 20
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

				unpack [(CrewView crew: crew) for crew in *player.crew]
			}
		},
		yui.Row {
			height: 276,
			events:
				update: (dt) =>
					if #@children == 0
						self\addChild ReactorView player

						for system in *player.systems
							self\addChild SystemView system, player, frame
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
					for weapon in *player.weapons
						self\addChild yui.Frame {
							width: 130,
							height: 100,
							x: offset,

							events:
								click: (button) =>
									if weapon.powered
										weapon.powered = false

										for system in *player.systems
											if system.name == "Weapons"
												system.power -= weapon.power
												return
									else
										powerUsed = 0
										for system in *player.systems
											powerUsed += system.power

										if powerUsed + weapon.power <= player.reactorLevel
											weapon.powered = true

											for system in *player.systems
												if system.name == "Weapons"
													system.power += weapon.power
													return
										else
											print "Not enough power!"

							theme:
								drawFrame: (renderer) =>
									renderer\setDrawColor 0x888888
									renderer\drawRect @rectangle!

									renderer\drawRect
										x: @realX + 5,
										y: @realY + 40,
										w: 100 * (weapon.charge / weapon.chargeTime),
										h: 10

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

playerPosition =
	x: 8
	y: 3
trajectory = player.crew[2]\pathfinding player.dijkstra, playerPosition, player.tiles
if trajectory
	for traj in *trajectory
		print traj.direction .. " " .. traj.tile.position.x .. " " .. traj.tile.position.y
else print "Destination unreachable"

c = true
while c do
	c = yui\run {w}

