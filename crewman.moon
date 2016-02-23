
class
	new: (species, name) =>
		@maxHealth = species.health or 100
		@health    = species.health or 100
		@quickness = species.quickness or 0.6
		@name = name or "unnamed person"
		@team = "ally"
		@boarding = false
		@position =
			x: 0
			y: 0
		@move =
			trajectory: {}
			trajInd: 1
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

	pathfinding: (dijkstra, room, tiles) =>
		unless room
			error "room is nil"
		
		local destination
		
		for i = room.width-1, 0, -1
			for j = room.height-1, 0, -1
				unless tiles[room.position.x+i][room.position.y+j].crewMember[@team]
						destination = tiles[room.position.x+i][room.position.y+j].position
		
		unless destination
			print "room is already full"
			return nil

		origInd = tiles[@position.x][@position.y].posInDijkstra
		destInd = tiles[destination.x][destination.y].posInDijkstra

		dijkstra[destInd].weight = 0
		dijkstra[destInd].goTo = "arrived"
		
		i = destInd
		
--		print dijkstra[i].goTo .. " " .. dijkstra[i].position.x .. " " .. dijkstra[i].position.y
		
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
						
--						print link.tile.goTo .. " " .. link.tile.position.x .. " " .. link.tile.position.y
				
			dijkstra[i].process = true
			i = origInd
			
			for j = 1, #dijkstra
				if dijkstra[j].weight < dijkstra[i].weight and not dijkstra[j].process
					i = j
			
			if i == origInd and dijkstra[origInd].weight == math.huge
				print "destination unreachable"
				return nil

		trajectory = {}
		
		trajectory[1] = dijkstra[origInd]
			
		tile = dijkstra[origInd]
		
		while tile.position.x != destination.x or tile.position.y != destination.y
			stop = false
			i = 1
			
			while tile.links[i] and not stop
				if tile.links[i].direction == tile.goTo
					print "im here"
					tile = tile.links[i].tile
					stop = true
					
				i+=1
				
			unless stop
				print "there is no such a direction"
				return nil
				
			trajectory[#trajectory+1] = tile

		for tile in *dijkstra
			tile.goTo = nil
			tile.weight = math.huge
		
		@move.trajectory = trajectory
		@move.trajInd = 1
		@move.trajectory[#@move.trajectory].crewMember.team = self
		@move.trajectory[1].crewMember[@team] = nil

	update: (dt, battle) =>
		unless @move.trajectory
			return
		
		unless #@move.trajectory > 1
			return
		
		dest = @move.trajectory[@move.trajInd+1].position

		dirx = dest.x - @move.trajectory[@move.trajInd].position.x
		diry = dest.y - @move.trajectory[@move.trajInd].position.y

		if dirx != 0 and diry != 0
			@position.x += (math.sqrt 2) * dirx * @quickness * dt / 1000
			@position.y += (math.sqrt 2) * diry * @quickness * dt / 1000
		else
			@position.x += dirx * @quickness * dt / 1000
			@position.y += diry * @quickness * dt / 1000

		if @position.x*dirx > dest.x*dirx
			@position.x = dest.x

		if @position.y*diry > dest.y*diry
			@position.y = dest.y

		if @position.x == dest.x and @position.y == dest.y
			@move.trajInd +=1
		
		if @move.trajInd == #@move.trajectory
			@move.trajInd = 1
			@move.trajectory = {}
