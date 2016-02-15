
class
	new: (name = "Unknown System") =>
		@name = name

	__tostring: =>
		"<System: \"#{@name}\">"

