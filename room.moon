
class
	new: (width = 2, height = 2) =>
		@width  = width
		@height = height

		@oxygen = 100

	clone: =>
		n = @@ @width, @height

		n

	__tostring: =>
		"<Room: #{@width}x#{@height}>"

	positionTiles: =>
		positions = {}
		
		for i = 0, @width - 1
			for j = 0, @height - 1
			
				tempPos = {
					x: @position.x + i
					y: @position.y +j
				}
				
				positions[#positions+1] = tempPos
	
		return positions
