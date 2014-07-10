require 'spec_helper'

describe "iams/show" do
  before(:each) do
    @iam = assign(:iam, stub_model(Iam,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
