class ItemsController < ApplicationController
 
  # GET /items
  # GET /items.json

  def index
    @items = Item.all
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @object = Bucket.object.new(key: item.key)
    @bucket = params[:bucket]
    @item = params[:item]
  end

  # ------------------------------
  #  Display object / item details
  # ------------------------------
  def show_item
    @storage_class_standard = true
    @bucket = params[:bucket]
    @item = params[:item]

    bucket = $s3.buckets[params[:bucket]] 
    @object = bucket.objects[@item]
    
    bucket.objects.each do |object|
      object.metadata['content-type'] = 'application/json'
      metadata = object.head
      @metadata = metadata.to_hash
    end
  end

  def new
    @bucket = params[:bucket_id]
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  # -----------------------------
  #  Create an object in a bucket 
  # -----------------------------
  def create
    bucket = $s3.buckets[params[:bucket_id]] 
    item = bucket.objects[params[:item][:name].original_filename]
    create_new_item(item)
  end

  # -------------------------------
  #  Delete an object from a bucket 
  # -------------------------------
  def delete_item
    @bucket = params[:bucket]
    @item = params[:item]
    $s3.buckets[@bucket].objects[@item].delete

    redirect_to bucket_path(params[:bucket]), notice: 'Item has been deleted'
  end

  # --------------------------
  #  List the object meta-data 
  # --------------------------
  def item_metadata
      @item = params[:item]
      @metadata = @item.head
  end

  # --------------------------------------------------------------------------
  # Set (and prove/show) an object's property to reduced redundancy / standard
  # --------------------------------------------------------------------------
  def change_storage_class 
    @bucket = params[:bucket]
    if params[:item].include? "$"
      @item = params[:item].gsub!("$", ".")
    elsif params[:item].include? "."
      @item = params[:item]
    else
      @item = "#{params[:item]}.JPG"
    end
    bucket = $s3.buckets[@bucket] 
    @object = bucket.objects[@item]
    @storage_class_standard = (params[:storage_class_standard] == "true")

    bucket.objects.each do |object|
      object.metadata['content-type'] = 'application/json'
      metadata = object.head
      @metadata = metadata.to_hash
    end

    if @storage_class_standard
      @object.reduced_redundancy=false
      @storage_class_standard = false
    else
      @object.reduced_redundancy=true
      @storage_class_standard = true
    end
    render "show_item", locals: {storage_class_standard: @storage_class_standard}
  end

  # -----------------------------------------------
  #  Create several different versions of an object
  # -----------------------------------------------
  def test_item_versions 
    @bucket = params[:bucket]
    bucket = $s3.buckets[@bucket]

    bucket.enable_versioning 

    obj = bucket.objects['test_object'] 
    obj.write('change 1')
    obj.write('change 2')
    obj.delete
    obj.write('change 3')

    @item = obj

    redirect_to bucket_path(params[:bucket]), notice: "New test object (#{@item.key}) created with changes to show versions"

  end

  # -----------------------------------------------
  #  Delete the odd numbered versions of an object
  # -----------------------------------------------
  def delete_odd_versions
    @bucket = params[:bucket]
    @item = params[:item]

    object = $s3.buckets[@bucket].objects[@item]
    i = 0

    object.versions.each do |obj_version|
      if i % 2 == 1
        object.delete(:version_id => obj_version.version_id)
      end
        i = i + 1  
    end

    redirect_to "/show_item/#{@bucket}/#{@item}", notice: "Deleted odd versions"
  end

  private

    def create_new_item item
    respond_to do |format|
      if item
        # uploading the object/item to bucket
        item.write(:file => Pathname.new(params[:item][:name].tempfile))

        format.html { redirect_to bucket_path(params[:bucket_id]), notice: "Uploading file #{params[:item][:name].original_filename} to bucket #{params[:bucket_id]}." }
        format.json { render :show, status: :created, location: item }
      else
        format.html { render :new }
        format.json { render json: item.errors, status: :unprocessable_entity }
      end
    end
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:name)
    end

end
