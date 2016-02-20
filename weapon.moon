
Projectile = require "projectile"

class
	new: (arg) =>
		@name = arg.name or "Test Weapon"
		@type = arg.type or "laser"

		@damage = arg.damage or 1
		@crewDamage = arg.crewDamage or 25
		@fireChance = arg.fireChance or 0
		@breachChance = arg.breachChance or 0
		@shots  = arg.shots  or 1

		@power = arg.power or 1
		@chargeTime = arg.chargeTime or 6000
		@charge = 0
		@projQuickness = arg.projQuickness or 1

		@powered = false

		@target = nil

	update: (dt, battle) =>
		if @powered
			@charge += dt
		else
			@charge -= dt * 2

		if @charge < 0
			@charge = 0
		elseif @charge >= @chargeTime
			if @target
				battle\addProjectile @\aim @target.ship, @target.room

				@target = nil
				@charge = 0
			else
				@charge = @chargeTime

	__tostring: =>
		"<Weapon: #{@type}, #{@damage}dmg, #{@shots}shots>"

	aim: (ship, room) =>
		projectile = Projectile self, ship, room
		return projectile
