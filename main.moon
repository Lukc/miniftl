
yui = require ".yui.init"
SDL = require "SDL"

Ship = require "ship"
Room = require "room"
System = require "system"
CrewMan = require "crewman"
Weapon = require "weapon"

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

	\addSystem (System "Engines"), test.rooms[1], 3
	\addSystem (System "Weapons", {
		powerMethod: (ship, powerUsed) =>
			for weapon in *ship.weapons
				print weapon
				if not weapon.powered
					if powerUsed + weapon.power <= ship.reactorLevel
						weapon.powered = true
						@power += weapon.power
						return true

					return
		unpowerMethod: (ship, powerUsed) =>
			for i = #ship.weapons, 1, -1
				weapon = ship.weapons[i]
				if weapon.powered
					weapon.powered = false
					@power -= weapon.power
					return true
	}), test.rooms[2], 5
	\addSystem (System "Shields", {
		powerMethod: (ship, powerUsed) =>
			if powerUsed <= ship.reactorLevel - 2 and @power <= @level - 2
				@power += 2
				true
		unpowerMethod: (ship) =>
			if @power > 0
				@power -= 2
				true
	}), test.rooms[4], 4
	\addSystem (System "Life Support"), test.rooms[5], 1

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

ShipView =
	new: (opts) =>
		yui.Widget.new self, opts

		unless opts.ship
			error "no opts.ship!"

		self.ship = opts.ship
		self.rotated = opts.rotated or false

		for door in *@ship.doors
			{:x, :y} = door.position

			local rect
			if door.type == "horizontal"
				rect =
					x: x * 48 + 8,
					y: (y + 1) * 48 - 6,
					w: 48 - 2 * 8,
					h: 12
			else
				rect =
					x: (x + 1) * 48 - 6,
					y: y * 48 + 8,
					w: 12,
					h: 48 - 2 * 8

			if @rotated
				rect.x, rect.y = rect.y, rect.x
				rect.w, rect.h = rect.h, rect.w

			rect.x += @realX
			rect.y += @realY

			yui.Widget.addChild self, yui.Button {
				x: rect.x,
				y: rect.y,
				width: rect.w,
				height: rect.h,
				events:
					click: (button) =>
						if button == 1
							door.opened = not door.opened
				theme:
					drawButton: (renderer) =>
						renderer\setDrawColor 0x000000
						renderer\fillRect self\rectangle!

						if @hovered
							if door.opened
								renderer\setDrawColor 0xFF8888
							else
								renderer\setDrawColor 0xBBBBBB
						else
							if door.opened
								renderer\setDrawColor 0xFF0000
							else
								renderer\setDrawColor 0x888888

						renderer\drawRect self\rectangle!
			}

	draw: (renderer) =>
		renderer\setDrawColor 0xFF8800
		renderer\drawRect @rectangle!

		for room in *@ship.rooms
			{:x, :y} = room.position

			rect =
				x: x * 48,
				y: y * 48,
				w: 48 * room.width,
				h: 48 * room.height

			if @rotated
				rect.x, rect.y = rect.y, rect.x
				rect.w, rect.h = rect.h, rect.w

			rect.x += @realX
			rect.y += @realY

			if room.system
				renderer\setDrawColor 0x00FFFF
			else
				renderer\setDrawColor 0xFFFFFF

			renderer\drawRect rect

		for crew in *@ship.crew
			rect = {
				x: crew.position.x * 48 + 8,
				y: crew.position.y * 48 + 8,
				w: 32,
				h: 32
			}

			if @rotated
				rect.x, rect.y = rect.y, rect.x
				rect.w, rect.h = rect.h, rect.w

			rect.x += @realX
			rect.y += @realY

			renderer\setDrawColor 0x00FF88
			renderer\drawRect rect

		yui.Widget.draw self, renderer

ShipView = yui.Object ShipView, yui.Widget

CrewView =
	new: (opts) =>
		unless opts.height
			opts.height = 52

		yui.Widget.new self, opts

		unless opts.crew
			error "no opts.crew!"

		@crew = opts.crew

		yui.Widget.addChild self, yui.Label {
			text: tostring @crew.name,
			x: 50
		}

	draw: (renderer) =>
		yui.Widget.draw self, renderer

		renderer\setDrawColor 0xFFFFFF
		renderer\drawRect @rectangle!

		renderer\setDrawColor 0x44FF88
		renderer\fillRect
			x: @realX + 50,
			y: @realY + 25,
			w: @crew.health / @crew.maxHealth * (@realWidth - 50 - 10),
			h: 10

CrewView = yui.Object CrewView, yui.Widget

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
						frame = yui.Frame {
							width: 70,
							events:
								update: (dt) =>
									--self.y = self.parent.height - self.realHeight
									self.realHeight = self.parent.height
						}

						self\addChild frame

						for i = 1, test.reactorLevel
							frame\addChild yui.Button {
								width: 40,
								height: 5,
								x: 10,
								y: frame.parent.height - 48 - 5 - i * 8,
								theme:
									drawButton: (renderer) =>
										totalPower = 0
										for system in *test.systems
											totalPower += system.power

										if test.reactorLevel - totalPower >= i
											renderer\setDrawColor 0x00FF00
										else
											renderer\setDrawColor 0xFF8800

										renderer\fillRect self\rectangle!
							}

						for system in *test.systems
							frame = yui.Frame {
								width: 60,
								events:
									update: (dt) =>
										--self.y = self.parent.height - self.realHeight
										self.realHeight = self.parent.height

								yui.Label {
									text: system.name
								},
								yui.Button
									width: 48,
									height: 48,
									x: 5,
									y: frame.parent.height - 48 - 5,
									events:
										click: (click) =>
											if click == 1
												test\power system
											elseif click == 3
												test\unpower system
							}

							self\addChild frame

							for i = 1, system.level
								frame\addChild yui.Button {
									width: 40,
									height: 5,
									x: 10,
									y: frame.parent.height - 48 - 5 - i * 8,
									theme:
										drawButton: (renderer) =>
											if system.power >= i
												renderer\setDrawColor 0x00FF00
											else
												renderer\setDrawColor 0xFF8800

											renderer\fillRect @rectangle!
								}
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

--testPosition =
--	x: 1
--	y: 6
--trajectory = test.crew[1]\pathfinding test.dijkstra, testPosition, test.tiles

--for traj in *trajectory
--	print traj.direction .. " " .. traj.tile.position.x .. " " .. traj.tile.position.y

c = true
while c do
	c = yui\run {w}

