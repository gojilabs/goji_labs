require_relative 'cannot_be_destroyed_now'

class ActiveRecord::Base

	before_destroy :destroyable!

  # override this method to return false when this object should not be destroyed
	def destroyable?
		true
	end

	def destroyable!
		raise ActiveRecord::CannotBeDestroyedNow.new(self) unless destroyable?
	end

	def title
		self.class.name.titleize
	end

end
