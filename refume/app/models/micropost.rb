class Micropost < ApplicationRecord
	validates :content, presence: true, length: { maximum: 1000 }
	validates :user_id, presence: true
	validates :category_id, presence: true
	validate :user_exists, :category_exists

	def user_exists
		begin
			@user = User.find_by_id(user_id)
		rescue ActiveRecord::RecordNotFound => e
			errors.add(:user_id, "The user identity associated with this post is invalid.")
		end
	end

	def category_exists
		begin
			@category = Category.find_by_id(category_id)
		rescue ActiveRecord::RecordNotFound => e
			errors.add(:category_id, "The category associated with this post is invalid.")
		end
	end
end