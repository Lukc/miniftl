
class
	new: (name, opt) =>
		@name = name

		@health = 100
		@value = 45

		@attackModifier     = 1
		@experienceModifier = 1
		@speedModifier      = 1

		@needsAir      = true
		@damagedByFire = true

		for key, value in pairs opt
			self[key] = value
		

