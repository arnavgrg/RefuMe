class MicropostsController < ApplicationController
	def new
		@micropost = Micropost.new
	end

	def create
		@micropost = Micropost.new(micropost_params)
		if @micropost.save
      		flash[:success] = "Post success!"
      		# TODO: redirect to a view displaying current post
        	render 'discussion'
    	else
    		flash[:error] = "Post error."
    		# TODO: render a 'new micropost' form view, display it here
      		render 'discussion'
    	end
	end

	def index
		# @posts = Micropost.where({category_id: Category.find(valid_item)})
		@posts = Micropost.all
		render 'discussion'
	end

	def show
		@posts = Micropost.find(valid_item)
	end

	private
		def micropost_params
			params.require(:micropost).permit(:content, :user_id, :category_id)
		end

		def valid_item
			params.require(:id)
		end

end