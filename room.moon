
class
	new: (width = 2, height = 2) =>
		@width  = width
		@height = height
		
	__tostring: =>
		"<Room: #{@width}x#{@height}>"

