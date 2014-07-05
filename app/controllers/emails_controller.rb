class EmailsController < ApplicationController

  # ---------
  #  MetaData
  # ---------
  def index
    @email = $ses.identities.email_addresses.map(&:identity) # lists all email addresses mapped
    @quota = $ses.quotas # Shows the sending quota for your account
    @statistics = $ses.statistics # Show the sending statistics for your account
    @identity = $ses.identities['ayesha345@gmail.com']
    @status = $ses.identities['ayesha345@gmail.com'].verified? # Lists the verified email sending addresses
  end

  def verify_email
  end

  # ------
  #  Email
  # ------
  def send_email
    @email = params[:email]
  end

  def update_email
    $ses.identities.verify(params[:email]) if params[:email].present? # Verifies an email address
    flash[:notice] = "Email verified"
    redirect_to emails_path
  end

  def attempt_email # Send an email to a specified email address

    if $ses.identities[params[:email]].verified?  
      @email = params[:email]
    else  
      @email = 'ayesha345@gmail.com'
    end  

    $ses.send_email(
      :subject => 'A Sample Email',
      :from => 'ayesha345@gmail.com',
      :to => @email,
      :body_text => 'Sample email text.',
      :body_html => '<h1>Sample Email</h1>')
    flash[:notice] = "Email Sent"
    redirect_to emails_path
  end

  def create
  end

  def show
  end
  
end