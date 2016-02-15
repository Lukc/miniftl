
class
	new: =>
		@fire = 0
		@breach = 0
		@air = 100
		
		@links ={}
		
	addLink: (tile, door) =>
		@links[#@links+1] = {
			tile: tile,
			door: door
		}
		
		tile.links[#tile.links+1] ={
			tile: self,
			door: door
		}

