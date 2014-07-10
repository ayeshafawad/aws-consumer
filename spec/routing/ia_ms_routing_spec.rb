require "spec_helper"

describe IaMsController do
  describe "routing" do

    it "routes to #index" do
      get("/iams").should route_to("iams#index")
    end

    it "routes to #new" do
      get("/iams/new").should route_to("iams#new")
    end

    it "routes to #show" do
      get("/iams/1").should route_to("iams#show", :id => "1")
    end

    it "routes to #edit" do
      get("/iams/1/edit").should route_to("iams#edit", :id => "1")
    end

    it "routes to #create" do
      post("/iams").should route_to("iams#create")
    end

    it "routes to #update" do
      put("/iams/1").should route_to("iams#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/iams/1").should route_to("iams#destroy", :id => "1")
    end

  end
end
