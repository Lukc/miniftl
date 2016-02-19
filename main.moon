
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
WeaponControl = require "widgets.weaponcontrol"

-- Game data.
systems = require "data.systems"
ships = require "data.ships"

-- Model
battle = Battle!

selection = {
	type: "none"
}

player = ships.raider2\clone!\finalize!

battle\addShip player, 1
battle\addShip ships.raider2\clone!\finalize!, 1

battle\addShip ships.raider\clone!\finalize!, 2
battle\addShip ships.raider2\clone!\finalize!, 2

with player
	\addCrew (CrewMan {}, "Luke"), {x: player.rooms[3].position.x, y: player.rooms[3].position.y}

	\addCrew (CrewMan {}, "Leia"), {x: player.rooms[4].position.x, y: player.rooms[4].position.y}

	.reactorLevel = 14

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

--cli.dump player

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

				unpack [(CrewView crew: crew, selection: selection) for crew in *player.crew]
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
	yui.Row {
		width: 400,
		height: 100,
		x: 1280 - 400 * 2 - 20 * 2,
		y: 800 - 100 - 20,

		events:
			update: (dt) =>
				if #@children == 0
					for weapon in *player.weapons
						self\addChild (WeaponControl
							player: player,
							weapon: weapon,
							selection: selection
						)
	},
	yui.Frame {
		width: 400,
		height: 100,
		x: 1280 - 400 - 20,
		y: 800 - 100 - 20
	}
}

c = true
while c do
	c = yui\run {w}

