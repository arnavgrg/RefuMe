class InfoController < ApplicationController

	def new
		@category = Category.new
	end

	def create
		@category = Category.new(category_params)
		if @category.save
			flash[:success] = "New category created!"
			render 'discussion'
		else
			flash[:error] = "Failed to create new category"
			render 'discussion', status: :unprocessable_entity
		end

	end

	def index
		@categories = Category.all
		render 'discussion'
	end

	private
		def category_params
			params.require(:category).permit(:name)
		end

		def valid_item
			params.require(:id)
		end

end
