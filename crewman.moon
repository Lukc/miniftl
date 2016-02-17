
class
	new: (species, name) =>
		@maxHealth = species.health or 100
		@health    = species.health or 100
		@name = name or "unnamed person"
		@position =
			x: 0
			y: 0
		@experience = {}
		for ability in *@@abilities
			@experience[ability] = 0

	abilities: {
		"pilot", "shields", "weapons", "repairs", "fights"
	}

	gainExperience: (domain) =>
		@experience[domain] += 1

