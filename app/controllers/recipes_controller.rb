class RecipesController < ApplicationController
	def index
    @recipes = if params[:keywords]
                 Recipe.where('name LIKE ?',"%#{params[:keywords]}%")
               else
                 []
               end
  end
  def show
  	@recipes = Recipe.find(params[:id])
  end
end
