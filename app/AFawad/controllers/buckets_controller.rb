class BucketsController < ApplicationController
  # GET /buckets
  # GET /buckets.json
  def index
    @buckets = $s3.buckets.map{ |x| Bucket.new(name: x.name) } 
  end

  # GET /buckets/1
  # GET /buckets/1.json
  # -----------------
  #  List all buckets
  # -----------------
  def show
    # call index in items controller and pass the bucket name
    #redirect_to @item
    bucket = $s3.buckets[params[:id]] 
    @bucket = Bucket.new(name: bucket.name)
    @objects = bucket.objects
    @policy = bucket.acl #Show the bucket policy for a named bucket
    @versioning = bucket.versioning_enabled?
  end

  # GET /buckets/new
  def new
    @bucket = Bucket.new
  end

  # POST /buckets
  # POST /buckets.json
  # -----------------
  #  Create a bucket
  # -----------------
  def create
    bucket_name = bucket_params[:name]
    bucket = $s3.buckets[bucket_name] # makes no request
    begin
      if not bucket.exists? # check if bucket already exists, if does not exist, create it
        create_new_bucket(bucket_name)
      else
        respond_to do |format|
        format.html { redirect_to buckets_url, notice: 'Bucket name already exists' }
        format.json { head :no_content }
        end
      end
    #rescue
      #create_new_bucket(bucket_name)
    end
  end


  # -----------------
  #  Delete a bucket
  # -----------------
  def delete_bucket
    unless params[:name].blank?
      bucket = $s3.buckets[params[:name]] 
      bucket.clear! 
      bucket.delete
      
      respond_to do |format|
        format.html { redirect_to buckets_url, notice: 'Bucket was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  # -------------------------------
  #  Enable versioning on an object 
  # -------------------------------
  def enable_versioning
     bucket_name = params[:bucket]
     bucket = $s3.buckets[bucket_name] 
     if bucket.versioning_enabled?
        bucket.suspend_versioning 
        respond_to do |format|
        format.html { redirect_to bucket_path(params[:bucket]), notice: 'Versioning disabled!' }
        format.json { head :no_content }
      end
     else 
        bucket.enable_versioning
        respond_to do |format|
        format.html { redirect_to bucket_path(params[:bucket]), notice: 'Versioning enabled!' }
        format.json { head :no_content }
      end
     end   

  end


  private

    # ---------------------------------
    #  Method called to create a bucket
    # ---------------------------------
    def create_new_bucket bucket_name
      bucket = $s3.buckets.create(bucket_name)
      respond_to do |format|
        if bucket
          @bucket = Bucket.new(name: bucket.name)
          format.html { redirect_to @bucket, notice: 'Bucket was successfully created.' }
          format.json { render :show, status: :created, location: @bucket }
        else
          format.html { render :new }
          format.json { render json: @bucket.errors, status: :unprocessable_entity }
        end
      end
    end


    # Use callbacks to share common setup or constraints between actions.
    def set_bucket
      @bucket = Bucket.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bucket_params
      params.require(:bucket).permit(:name)
    end


end
