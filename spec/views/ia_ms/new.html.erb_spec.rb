require 'spec_helper'

describe "iams/new" do
  before(:each) do
    assign(:iam, stub_model(Iam,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new iam form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", iams_path, "post" do
      assert_select "input#iam_name[name=?]", "iam[name]"
    end
  end
end
