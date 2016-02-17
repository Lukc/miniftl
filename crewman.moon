
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

	move: destination =>
		@position = destination

	pathfinding = (dijkstra, origin, destination, tiles) =>
		if tiles[destination.x][destination.y] and tiles[origin.x][origin.y]
			destInd = tiles[destination.x][destination.y].posInDijkstra
			origInd = tiles[origin.x][origin.y].posInDijkstra
			dijkstra[destInd].weight = 0
			i = destInd
			while i != origInd
				for link in *dijkstra[i].links
					unless link.tile.process
						if link.tile.weight > dijkstra[i].weight+1
							link.tile.weight = dijkstra[i].weight+1
							switch link.direction
								when "right" then link.tile.goTo = "left"
								when "left" then link.tile.goTo = "right"
								when "up" then link.tile.goTo = "down"
								when "down" then link.tile.goTo = "up"
				dijkstra[i].process = true
				i = 1
				for j = 1, #dijkstra
					if dijkstra[j].weight < dijkstra[i].weight
						i = j
