class DynamotablesController < ApplicationController
  
  # ----------------
  #  List all Tables
  # ----------------
  def index
    @dynamotables = $dynamodb.tables.map{ |x| Dynamotable.new(name: x.name) } 
  end

  def new
    @dynamotable = Dynamotable.new
  end

  # ----------------------
  #  Create a Dynamo Table
  # ----------------------
  def create 
    table_name = dynamo_params[:name]
    table = $dynamodb.tables[table_name] # makes no request
    begin
      if not table.exists? # check if table already exists, if does not exist, create it
        table = $dynamodb.tables.create(
                    table_name, 10, 5,
                    :hash_key => { :id => :number },
                    :range_key => { :range => :number },
                    :index_name => { :color => :string } # include a local secondary index
                    )
        sleep 1 while table.status == :creating

        redirect_to dynamotables_url, notice: 'Table was successfully created.'
      else
        respond_to do |format|
        format.html { redirect_to dynamotables_url, notice: 'Table name already exists' }
        format.json { head :no_content }
        end
      end
    end
  end

  # ----------------------
  #  Delete a Dynamo Table
  # ----------------------
  def delete_table
    unless params[:name].blank?
      table_name = params[:name]
      table = $dynamodb.tables[table_name] # makes no request
      table.delete 
      
      respond_to do |format|
        format.html { redirect_to dynamotables_url, notice: 'Table was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  # ---------------------------------
  #  List all Table Items and Details
  # ---------------------------------
  def show_item
    table_name = params[:name]
    @dynamotable = $dynamodb.tables[table_name] # makes no request
    @items = @dynamotable.load_schema.items # Get item
    $dynamodbclient = AWS::DynamoDB::Client.new(
        :access_key_id => ENV["S3_ACCESS_KEY"],
        :secret_access_key => ENV["S3_SECRET_KEY"])
    @table_description = $dynamodbclient.describe_table(:table_name=>@dynamotable.name) 

    @ndt = @table_description["Table"]["ProvisionedThroughput"]["NumberOfDecreasesToday"]
    @rcu = @table_description["Table"]["ProvisionedThroughput"]["ReadCapacityUnits"]
    @wcu = @table_description["Table"]["ProvisionedThroughput"]["WriteCapacityUnits"]

  end

  # ------------------------------
  #  Update Provisioned Throughput
  # ------------------------------
  def update_provisioned_throughput
    table_name = params[:name]
    @dynamotable = $dynamodb.tables[table_name] # makes no request
    $dynamodbclient = AWS::DynamoDB::Client.new(
        :access_key_id => ENV["S3_ACCESS_KEY"],
        :secret_access_key => ENV["S3_SECRET_KEY"])
    options = {}
    options[:read_capacity_units] ||= 7
    options[:write_capacity_units] ||= 7
    client_opts = {}
    client_opts[:table_name] = table_name 
    client_opts[:provisioned_throughput] = options
    $dynamodbclient.update_table(client_opts)
    # @table_description["Table"]["ProvisionedThroughput"]["WriteCapacityUnits"] = 15

    redirect_to "/show_item/#{table_name}", notice: 'Updated ReadCapacityUnits to 7 and WriteCapacityUnits to 7'

  end


  # ------------------
  #  Create New Items
  # ------------------
  def new_item
    table_name = params[:name]
    @dynamotable = $dynamodb.tables[table_name] # makes no request
    @dynamotable.hash_key = [:id, :number]
    @dynamotable.range_key = [:range, :number]
    # Put item
    item = @dynamotable.load_schema.items.put(:id => 4, :color => 'yellow', :range => 4 ) 

    redirect_to "/show_item/#{table_name}", notice: 'Created test item'
  end

  # ------------------
  #  Batch Write Items
  # ------------------
  def batch_item
    table_name = params[:name]
    @dynamotable = $dynamodb.tables[table_name] # makes no request

    @dynamotable.hash_key = [:id, :number]
    @dynamotable.range_key = [:range, :number]
    @dynamotable.batch_write(
        :put => [
        { :id => 1, :color => 'red', :range => 1 },
        { :id => 2, :color => 'blue', :range => 2 },
        { :id => 3, :color => 'green', :range => 3 },
      ])

    redirect_to "/show_item/#{table_name}", notice: 'Batch write items completed'
  end

  # -------------
  #  Update Items
  # -------------
  def update_item
    table_name = params[:name]
    @dynamotable = $dynamodb.tables[table_name] # makes no request
    
    @item = @dynamotable.load_schema.items[1,1]
    @item.attributes["color"] = "silver"

    @item = @dynamotable.load_schema.items[2,2]
    @item.attributes["color"] = "silver"

    @item = @dynamotable.load_schema.items[3,3]
    @item.attributes["color"] = "silver"

    redirect_to "/show_item/#{table_name}", notice: 'Update test items'
  end


  # -------------
  #  Delete Items
  # -------------
  def delete_item
    table_name = params[:name]
    @dynamotable = $dynamodb.tables[table_name] # makes no request
    
    @item = @dynamotable.load_schema.items[1,1]
    @item.delete

    @item = @dynamotable.load_schema.items[2,2]
    @item.delete

    @item = @dynamotable.load_schema.items[3,3]
    @item.delete

    @item = @dynamotable.load_schema.items[4,4]
    @item.delete

    redirect_to "/show_item/#{table_name}", notice: 'Deleted test items'
  end

  # ------------------
  #  Query Table Items
  # ------------------
  def query_item
    table_name = params[:name]
    @dynamotable = $dynamodb.tables[table_name] # makes no request
    @dynamotable.load_schema
    @results = @dynamotable.items.query(:hash_value => 2, :range_value => 1..100)

  end

  # -----------------
  #  Scan Table Items
  # -----------------
  def scan_item
    table_name = params[:name]
    @dynamotable = $dynamodb.tables[table_name] # makes no request
    @dynamotable.load_schema
    @results = @dynamotable.items.select(:limit => 3)

  end

    # Use callbacks to share common setup or constraints between actions.
    def set_dynamotable
      @dynamotable = Dynamotable.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dynamo_params
      params.require(:dynamotable).permit(:name)
    end

end
