
class
	new: =>
		@ships = {}
		@projectiles = {}
		@fleets = {{}, {}}

	addShip: (ship, fleet) =>
		@ships[#@ships+1] = ship
		@fleets[fleet][#@fleets[fleet]+1] = ship

	addProjectile: (proj) =>
		@projectiles[#@projectiles + 1] = proj

	removeProjectile: (proj) =>
		for i = 1, #@projectiles
			if @projectiles[i] == proj
				for j = i, #@projectiles
					@projectiles[j] = @projectiles[j+1]

				return true

	fleetOf: (ship) =>
		for s in *@fleets[1]
			if s == ship
				return 1

		for s in *@fleets[2]
			if s == ship
				return 2

	update: (dt) =>
		for ship in *@ships
			ship\update dt, self

		for projectile in *@projectiles
			projectile\update dt, self

