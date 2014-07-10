require 'spec_helper'

describe "iams/index" do
  before(:each) do
    assign(:iams, [
      stub_model(Iam,
        :name => "Name"
      ),
      stub_model(Iam,
        :name => "Name"
      )
    ])
  end

  it "renders a list of iams" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
