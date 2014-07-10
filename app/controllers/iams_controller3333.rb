class IamsController < ApplicationController
  
  def new
    @iam = Iam.new
  end

  # -----------------
  #  Create a Group
  # -----------------
  def create
  	group_name = iam_params[:name]
  	pry
  end	

end