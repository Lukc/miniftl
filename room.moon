
class
	new: (width = 2, height = 2) =>
		@width  = width
		@height = height

	clone: =>
		n = @@ @width, @height

		n

	__tostring: =>
		"<Room: #{@width}x#{@height}>"

