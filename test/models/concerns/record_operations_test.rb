require "test_helper"

class RecordOperationsTest < ActiveSupport::TestCase
  include RecordOperations

  def setup
    Current.user = users(:user1)
    @params_page = 1
  end

  test "search_objects method should filter objects based on query" do
    query = customers(:customer1).email

    filtered_objects = Customer.search_objects(Customer.all, [:email], query)

    filtered_objects.each do |object|
      assert_includes object.email.downcase, query.downcase
    end
  end

  test "load_objects method should load objects with specified fields" do
    objects = Customer.load_objects(Customer::FIELDS_TO_LOAD, @params_page)

    assert_equal objects.length, Customer.where(user_id: Current.user.id).count
    assert_equal objects.first.attributes.length, Customer::FIELDS_TO_LOAD.length

    objects.each do |object|
      assert_includes object.attributes.keys, "id"
      assert_includes object.attributes.keys, "name"
      assert_includes object.attributes.keys, "email"
      assert_includes object.attributes.keys, "phone"
      assert_includes object.attributes.keys, "notes"
    end
  end

  test "load_objects should allow additional custom query" do
    objects = Customer.load_objects(Customer::FIELDS_TO_LOAD, @params_page) { |q| q.where(email: "john@john.cc") }
    objects.each do |obj|
      assert_equal "john@john.cc", obj.email
    end
  end
end
