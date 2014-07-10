require 'spec_helper'

describe "iams/edit" do
  before(:each) do
    @iam = assign(:iam, stub_model(Iam,
      :name => "MyString"
    ))
  end

  it "renders the edit iam form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", iam_path(@iam), "post" do
      assert_select "input#iam_name[name=?]", "iam[name]"
    end
  end
end
