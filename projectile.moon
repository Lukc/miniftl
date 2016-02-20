
class
	new: (weapon, ship, room) =>
		@weapon = weapon
		@targetShip = ship
		@targetRoom = room
		@distance = 0

	update: (dt) =>
		@distance += dt * weapon.projQuickness
		if @distance >= 1
			ship.damage(self)
			return 1
