class PostExampleController < ActionController::Base

  def create
    @received_headers = request.headers
    @received_body = request.body
    Rails.logger.debug "Received request headers\n #{@received_headers.inspect} \nwith body \n#{@received_body.inspect}"
    render :confirm, status: :ok
  end

  def confirm
  end
  
end

