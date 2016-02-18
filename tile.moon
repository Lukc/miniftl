
class
	new:(x,y)  =>
		@fire = 0
		@breach = 0
		@air = 100
		@links ={}
		@position =
			x: x,
			y: y
		
	addLink: (tile, door, direction) =>
		@links[#@links+1] = {
			direction: direction,
			tile: tile,
			door: door
		}
		
		local direction2
		if tile
			switch direction
				when "up"
					direction2 = "down"
				when "down"
					direction2 = "up"
				when "right"
					direction2 = "left" 
				when "left"
					direction2 = "right"
			
			tile.links[#tile.links+1] = {
				direction: direction2,
				tile: self,
				door: door
			}

