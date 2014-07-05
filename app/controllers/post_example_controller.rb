class PostExampleController < ActionController::Base

  def create
    @received_headers = request.headers
    @received_body = request.body
    render :confirm, status: :ok
  end

  def confirm
  end
  
end

