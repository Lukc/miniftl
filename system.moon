
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

		-- Exotic powering methods. Like shields or weapons.
		n.powerMethod   = @powerMethod
		n.unpowerMethod = @unpowerMethod

		-- Special characteristics taken care of internally, like shields.
		n.special = @special

		if @oxygen
			n.oxygen = [x for x in *@oxygen]

		-- Does not use power to work.
		n.powerless = @powerless

		return n

	__tostring: =>
		"<System: \"#{@name}\", #{@power} power>"

