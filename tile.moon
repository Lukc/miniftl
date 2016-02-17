
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
		
		if tile
			if self.links[#@links].direction == "up"
				direction = "down"
			elseif self.links[#@links].direction == "down"
				direction = "up"
			elseif self.links[#@links].direction == "right"
				direction = "left"
			else
				direction = "right"
			
			tile.links[#tile.links+1] = {
				direction: direction,
				tile: self,
				door: door
			}

