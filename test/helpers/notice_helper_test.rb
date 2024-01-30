require "test_helper"

class NoticeHelperTest < ActionView::TestCase
  include NoticeHelper

  def setup
    @customer = customers(:customer1)
  end

  test "should return correct notice message for created object" do
    customer = Customer.create(first_name: "Slavko", last_name: "Slavkovic", email: "slavko@rr.cc")

    assert_equal "Customer #{customer.id} was successfully created!", notice_msg(customer, "created")
  end

  test "should return correct notice message for updated object" do
    @customer.first_name = "Johnnn"

    assert_equal "Customer 1 was successfully updated!", notice_msg(@customer, "updated")
  end

  test "should return correct notice message for deleted object" do
    @customer.destroy

    assert_equal "Customer 1 was successfully deleted!", notice_msg(@customer, "deleted")
  end
end
