
class
	new: (weapon, ship, room) =>
		@weapon = weapon
		@targetShip = ship
		@targetRoom = room
		@distance = 0

	update: (dt, battle) =>
		@distance += dt * @weapon.projQuickness

		if @distance >= 1
			@targetShip\damage self

			battle\removeProjectile self
