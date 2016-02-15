
class
	new: (width = 2, height = 2, x) =>
		@width  = width
		@height = height

	__tostring: =>
		"<Room: #{@width}x#{@height}>"

