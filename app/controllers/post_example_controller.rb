class PostExampleController < ActionController::Base

  def create
    @received_body = JSON.parse request.body.read.to_s.strip
    puts "Received request body:\n#{@received_body.inspect}"
    render :confirm, status: :ok

  end

  def confirm
  end
  
end

