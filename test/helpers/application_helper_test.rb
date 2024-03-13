require "test_helper"
require "mocha/minitest"

class ApplicationHelperTest < ActionView::TestCase
  include ApplicationHelper

  def setup
    Current.user = users(:user1)
    @cars = Car.where(user_id: Current.user.id)
    @object = customers(:customer1)

    @back_btn = "Back btn"
    @show_btn = "Show btn"
    @edit_btn = "Edit btn"
    @delete_btn = "Delete btn"

    @index_title = "Customers"
    @new_titile = "New customer"
    @edit_titile = "Editing customer"

    @index = "index"
    @show = "show"
    @new = "new"
    @edit = "edit"
    @delete = "delete"

    back_link_params = { action: @index }
    show_link_params = { action: @show }
    edit_link_params = { action: @edit }
    delete_link_params = { action: @delete }

    link_options = { class: "outline", role: "button" }
    link_options_sec = { class: "secondary outline", role: "button" }

    self.stubs(:link_to).
      with("Back to customers", back_link_params, **link_options_sec).
      returns(@back_btn)

    self.stubs(:link_to).
      with("Show this customer", show_link_params, **link_options).
      returns(@show_btn)

    self.stubs(:link_to).
      with("Edit customer", edit_link_params, **link_options).
      returns(@edit_btn)

    self.stubs(:link_to).
      with("Delete this customer", delete_link_params, **link_options_sec).
      returns(@delete_btn)
  end

  # Tests for page_btn_links function
  test "page_btn_links should return correct links for edit action" do
    links = page_btn_links(@object, @edit)

    assert_equal links, "#{@show_btn} #{@back_btn}"
  end

  test "page_btn_links should return correct links for 'show' action" do
    links = page_btn_links(@object, @show)

    assert_equal links, "#{@edit_btn} #{@delete_btn} #{@back_btn}"
  end

  test "page_btn_links should return back link for 'new' action" do
    links = page_btn_links(@object, @new)

    assert_equal links, "#{@back_btn}"
  end

  test "page_btn_links should return back link for 'delete' action" do
    links = page_btn_links(@object, @delete)

    assert_equal links, "#{@back_btn}"
  end

  test "page_btn_links should return nil for 'index' action" do
    links = page_btn_links(@object, @index)

    assert_nil links
  end

  test "page_btn_links should return nil for unexpected action" do
    links = page_btn_links(@object, "123abc")

    assert_nil links
  end

  # Tests for page_title function
  test "page_title should return correct title for 'index' action" do
    self.stubs(:action_name).returns(@index)
    title = page_title(@object.class)

    assert_equal @index_title, title
  end

  test "page_title should return correct title for 'edit' action" do
    self.stubs(:action_name).returns(@edit)
    title = page_title(@object)

    assert_equal @edit_titile, title
  end

  test "page_title should return correct title for 'new' action" do
    self.stubs(:action_name).returns(@new)
    title = page_title(@object)

    assert_equal @new_titile, title
  end

  test "page_title should return nil for 'show' action" do
    self.stubs(:action_name).returns(@show)
    title = page_title(@object)

    assert_nil title
  end

  test "page_title should return nil for 'delete' action" do
    self.stubs(:action_name).returns(@delete)
    title = page_title(@object)

    assert_nil title
  end

  test "page_title should return nil for unexpected action" do
    self.stubs(:action_name).returns("123abc")
    title = page_title(@object)

    assert_nil title
  end

  # Tests for truncate_value function
  test "truncate_value should return empty string if value is nil" do
    assert_equal "", truncate_value(nil)
  end

  test "truncate_value should return value if it is shorter than 20 characters" do
    assert_equal "Less than 20", truncate_value("Less than 20")
  end

  test "truncate_value should truncate value longer than 20 characters" do
    long_value = "Very long value with more that 20 characters"
    assert_equal "Very long value w...", truncate_value(long_value)
  end

  # Tests for visible_attributes function
  test "visible_attributes should return attributes with specified fields removed" do
    visible_attrs = visible_attributes(
      @cars.first,
      ["price", "user_id", "created_at", "updated_at"]
    )

    assert_equal visible_attrs.keys.sort, ["brand", "model", "production_year", "customer_id"].sort
    assert_nil visible_attrs["price"]
    assert_nil visible_attrs["user_id"]
    assert_nil visible_attrs["created_at"]
    assert_nil visible_attrs["updated_at"]
  end

  test "visible_attributes should rise ArgumentError if fields_to_remove is not an array" do
    assert_raises ArgumentError do
      visible_attributes(@car, "price")
    end
  end
end
