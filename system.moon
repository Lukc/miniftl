
class
	new: (name = "Unknown System") =>
		@name = name

		@power = 0
		@level = 0

	clone: =>
		n = @@ @name

		n.level = @level

		return n

	__tostring: =>
		"<System: \"#{@name}\">"

