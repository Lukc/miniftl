
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

	move: (destination) =>
		@position = destination

	pathfinding: (dijkstra, destination, tiles) =>
		if tiles[destination.x][destination.y] and tiles[@position.x][@position.y]
			destInd = tiles[destination.x][destination.y].posInDijkstra
			origInd = tiles[@position.x][@position.y].posInDijkstra
			
			dijkstra[destInd].weight = 0
			dijkstra[destInd].goTo = "arrived"
			
			i = destInd
			
--			print dijkstra[i].goTo .. " " .. dijkstra[i].position.x .. " " .. dijkstra[i].position.y
			
			while i != origInd
			
				for link in *dijkstra[i].links
				
					if link.tile
					
						if link.tile.weight > dijkstra[i].weight+1 and not link.tile.process
							link.tile.weight = dijkstra[i].weight+1
							
							if dijkstra[i].position.x < link.tile.position.x
								link.tile.goTo = "left"
							elseif dijkstra[i].position.x > link.tile.position.x
								link.tile.goTo = "right"
							elseif dijkstra[i].position.y < link.tile.position.y
								link.tile.goTo = "up"
							elseif dijkstra[i].position.y > link.tile.position.y
								link.tile.goTo = "down"
							
							print link.tile.goTo .. " " .. link.tile.position.x .. " " .. link.tile.position.y
				
				dijkstra[i].process = true
				i = origInd
				
				for j = 1, #dijkstra
					if dijkstra[j].weight < dijkstra[i].weight and not dijkstra[j].process
						i = j
				
				if i == origInd and dijkstra[origInd].weight == math.huge
					print "destination unreachable"
					return nil

			trajectory = {}
			
			trajectory[1] =
				tile: dijkstra[origInd]
				direction: dijkstra[origInd].goTo
			
			tile = dijkstra[origInd]
			
			while tile.position.x != destination.x or tile.position.y != destination.y
				stop = false
				i = 1
				
				while tile.links[i] and not stop
					if tile.links[i].direction == tile.goTo
						tile = tile.links[i].tile
						stop = true
						
					i+=1
					
				unless stop
					error "there is no such a direction"
					
				trajectory[#trajectory+1] =
					tile: tile
					direction: tile.goTo

			for tile in *dijkstra
				tile.goTo = nil
				tile.weight = math.huge
				
			return trajectory

