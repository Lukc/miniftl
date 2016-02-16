
class
	new: (species) =>
		@health = species.health or 100
		@name = "unnamed person"
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

	move: destination =>
		@position = destination

