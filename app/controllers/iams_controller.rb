class IamsController < ApplicationController
  before_action :set_iam, only: [:show, :edit, :update, :destroy]

  # GET /iams
  # GET /iams.json
  def index
    @iams = $iam.groups.map{ |x| Iam.new(name: x.name) } 
    @users = $iam.users
  end

  # GET /iams/1
  # GET /iams/1.json
  def show
  end

  # GET /iams/new
  def new
    @iam = Iam.new
  end

  # GET /iams/1/edit
  def edit
  end

  # -----------------
  #  Create a Group
  # -----------------
  def create
    group_name = iam_params[:name]
    group = $iam.groups[group_name] # makes no request

    respond_to do |format|
      if not group.exists? # check if group already exists, if does not exist, create it
        $iam.groups.create(group_name)
        format.html { redirect_to @iam, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @iam }
      else
        format.html { render :new }
        format.json { render json: @iam.errors, status: :unprocessable_entity }
      end
    end
        #@iam = Iam.new(iam_params)
  end

  # ---------------------------------
  #  List all Groups and its Users
  # ---------------------------------
  def show_group
    group_name = params[:name]
    @group = $iam.groups[group_name]
    @users = @group.users
  end  

  # -----------------
  #  Create 3 Users
  # -----------------
  def create_users

    @group = $iam.groups[params[:name]]
    @user = $iam.users[params[:username]]
    #user = $iam.users[params[:name]]

    respond_to do |format|
      if not @user.exists? # check if user already exists, if does not exist, create it
        $iam.users.create(@user.name)
        format.html { redirect_to iams_path, notice: 'User created.' }
      else
        format.html { redirect_to iams_path, notice: 'Error' }
      end
    end
        #@iam = Iam.new(iam_params)
  end

  # ----------------------
  #  Add 2 Users to Group
  # ----------------------
  def add_users
    group_name = params[:name]
    @group = $iam.groups[group_name]

    respond_to do |format|
      if @group.exists? # check if group already exists, then add user
        @group.users.add($iam.users["Ayesha"])
        @group.users.add($iam.users["Fawad"])
        format.html { redirect_to iams_path, notice: 'User is added.' }
      else
        format.html { redirect_to iams_path, notice: 'Error' }
      end
    end

  end

  # --------------------------
  #  Create a Policy for S3
  # --------------------------
  def create_policy_s3

    AWS.config(
        :access_key_id => ENV["S3_ACCESS_KEY"], 
        :secret_access_key => ENV["S3_SECRET_KEY"])

    # naming policy 
    role_name = 's3-read-write'
    policy_name = 's3-read-write'
    profile_name = 's3-read-write'   

    # building a custom policy 
    policy = AWS::IAM::Policy.new
    policy.allow(
      :actions => ["s3:Read*","s3:Write*","s3:Get*","s3:List*"], 
      :resources => '*')

    # EC2 can generate session credentials
    assume_role_policy_document = '{"Version":"2008-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":["ec2.amazonaws.com"]},"Action":["sts:AssumeRole"]}]}'
   
    # creating a role
    $iam.client.create_role(
      :role_name => role_name,
      :assume_role_policy_document => assume_role_policy_document)

    # adding policy to role
    $iam.client.put_role_policy(
      :role_name => role_name,
      :policy_name => policy_name,
      :policy_document => policy.to_json)

    # creating a profile for the role
    $response = $iam.client.create_instance_profile(
      :instance_profile_name => instance_profile_name)
     
    # ARN
    $profile_arn = response[:instance_profile][:arn]
     
    $iam.client.add_role_to_instance_profile(
      :instance_profile_name => instance_profile_name,
      :role_name => role_name)

    # you can use the profile name or ARN as the :iam_instance_profile option
    $ec2 = AWS::EC2.new
    $ec2.instances.create(:image_id => "inst_id_1", :iam_instance_profile => profile_name)

  end

  # --------------------------
  #  Create a Policy for EC2
  # --------------------------
  def create_policy_ec2

    AWS.config(
        :access_key_id => ENV["S3_ACCESS_KEY"], 
        :secret_access_key => ENV["S3_SECRET_KEY"])

    # naming policy 
    role_name = 'ec2-start-stop'
    policy_name = 'ec2-start-stop'
    profile_name = 'ec2-start-stop'   

    # building a custom policy 
    policy = AWS::IAM::Policy.new
    policy.allow(
      :actions => ["ec2:StartInstances","ec2:StopInstances"],
      :resources => '*')

    # EC2 can generate session credentials
    assume_role_policy_document = '{"Version":"2008-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":["ec2.amazonaws.com"]},"Action":["sts:AssumeRole"]}]}'
   
    # creating a role
    $iam.client.create_role(
      :role_name => role_name,
      :assume_role_policy_document => assume_role_policy_document)

    # adding policy to role
    $iam.client.put_role_policy(
      :role_name => role_name,
      :policy_name => policy_name,
      :policy_document => policy.to_json)

    # creating a profile for the role
    $response = $iam.client.create_instance_profile(
      :instance_profile_name => instance_profile_name)
     
    # ARN
    $profile_arn = response[:instance_profile][:arn]
     
    $iam.client.add_role_to_instance_profile(
      :instance_profile_name => instance_profile_name,
      :role_name => role_name)

    # you can use the profile name or ARN as the :iam_instance_profile option
    $ec2 = AWS::EC2.new
    $ec2.instances.create(:image_id => "ami-inst-id-1", :iam_instance_profile => profile_name)

  end

  # ---------------------------
  #  Delete a Policy from Role
  # ---------------------------

  def delete_policy

  end


  # -------------
  #  Delete Role
  # -------------

  def delete_role
    $iam.client.delete_role('ec2-start-stop')
    $iam.client.delete_role('s3-read-write')
  end


  def delete_user

    @user = $iam.users[params[:username]]
    #user = $iam.users[params[:name]]

    respond_to do |format|
      if @user.exists? # check if user already exists, if does not exist, create it
        $iam.users[params[:username]].delete!
        format.html { redirect_to iams_path, notice: 'User Deleted.' }
      else
        format.html { redirect_to iams_path, notice: 'Error' }
      end
    end
        #@iam = Iam.new(iam_params)
  end


  # -----------------
  #  Delete all Users
  # -----------------
  def delete_users

    $iam.users.each do |user|
      user.delete!
    end

    redirect_to iams_path, notice: 'All Users Deleted.'
  end

  # PATCH/PUT /iams/1
  # PATCH/PUT /iams/1.json
  def update
    respond_to do |format|
      if @iam.update(iam_params)
        format.html { redirect_to @iam, notice: 'Iam was successfully updated.' }
        format.json { render :show, status: :ok, location: @iam }
      else
        format.html { render :edit }
        format.json { render json: @iam.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /iams/1
  # DELETE /iams/1.json
  def destroy
    @iam.destroy
    respond_to do |format|
      format.html { redirect_to iams_url, notice: 'Iam was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_iam
      @iam = Iam.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def iam_params
      params.require(:iam).permit(:name).permit(:username)
    end
end
