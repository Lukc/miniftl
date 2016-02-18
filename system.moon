
class
	new: (name = "Unknown System", opts) =>
		@name = name

		@power = 0
		@level = 0
		@health = 0

		if opts
			for key, value in pairs opts
				self[key] = value

	clone: =>
		n = @@ @name

		n.level = @level

		n.powerMethod   = @powerMethod
		n.unpowerMethod = @unpowerMethod

		n.special = @special

		return n

	__tostring: =>
		"<System: \"#{@name}\", #{@power} power>"

