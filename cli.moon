
_M = {}

_M.dump = (ship) ->
	buffer = [{} for i = 1, 24]
	for j = 1, 24
		for i = 1, 80
			buffer[j][i] = " "

	for j = 1, ship.tiles.height
		for i = 1, ship.tiles.width
			tile = ship.tiles[i][j]
			if tile
				buffer[j*2-1][i*2] = "-"
				buffer[j*2+1][i*2] = "-"
				buffer[j*2][i*2+1] = "|"
				buffer[j*2][i*2-1] = "|"
				buffer[j*2][i*2] = "0"
				for h = 1, 4
					if tile.links[h]
						if tile.links[h].direction == "up"
							if tile.links[h].door
								buffer[j*2-1][i*2] = "~"
							else
								buffer[j*2-1][i*2] = " "
						elseif tile.links[h].direction == "right"
							if tile.links[h].door
								buffer[j*2][i*2+1] = "/"
							else
								buffer[j*2][i*2+1] = " "
						elseif tile.links[h].direction == "down"
							if tile.links[h].door
								buffer[j*2+1][i*2] = "~"
							else
								buffer[j*2+1][i*2] = " "
						elseif tile.links[h].direction == "left"
							if tile.links[h].door
								buffer[j*2][i*2-1] = "/"
							else
								buffer[j*2][i*2-1] = " "

	for line in *buffer
		for char in *line
			io.write char
		io.write "\n"

_M

