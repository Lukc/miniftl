
class
	new: (arg) =>
		@name = arg.name or "Test Weapon"
		@type = arg.type or "laser"

		@damage = arg.damage or 1
		@shots  = arg.shots  or 1

		@power = arg.power or 1
		@chargeTime = arg.chargeTime or 6

		@powered = false

	__tostring: =>
		"<Weapon: #{@type}, #{@damage}dmg, #{@shots}shots>"

