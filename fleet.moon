
class
	new: =>
		@ships = {}

	addShip: (ship) =>
		@ships[#@ships+1] = ship

