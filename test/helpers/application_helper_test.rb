require "test_helper"
require "minitest/autorun"
require "mocha/minitest"

class ApplicationHelperTest < ActionView::TestCase
  include ApplicationHelper

  def setup
    @object = customers(:customer1)
    @back_btn = "Back btn"
    @show_btn = "Show btn"
    @edit_btn = "Edit btn"
    @delete_btn = "Delete btn"

    back_link_params = { action: "index" }
    show_link_params = { action: "show" }
    edit_link_params = { action: "edit" }
    delete_link_params = { action: "delete" }

    link_options = { class: "outline", role: "button" }
    link_options_sec = { class: "secondary outline", role: "button" }

    self.stubs(:link_to).
      with("Back to customers", back_link_params, link_options_sec).
      returns(@back_btn)

    self.stubs(:link_to).
      with("Show this customer", show_link_params, link_options).
      returns(@show_btn)

    self.stubs(:link_to).
      with("Edit customer", edit_link_params, link_options).
      returns(@edit_btn)

    self.stubs(:link_to).
      with("Delete this customer", delete_link_params, link_options_sec).
      returns(@delete_btn)
  end

  # Tests for page_btn_links function
  test "page_btn_links should return correct links for edit action" do
    links = page_btn_links(@object, "edit")

    assert_equal links, "#{@show_btn} #{@back_btn}"
  end

  test "page_btn_links should return correct links for 'show' action" do
    links = page_btn_links(@object, "show")

    assert_equal links, "#{@edit_btn} #{@delete_btn} #{@back_btn}"
  end

  test "page_btn_links should return back link for 'new' action" do
    links = page_btn_links(@object, "new")

    assert_equal links, "#{@back_btn}"
  end

  test "page_btn_links should return back link for 'delete' action" do
    links = page_btn_links(@object, "delete")

    assert_equal links, "#{@back_btn}"
  end

  test "page_btn_links should return nil for 'index' action" do
    links = page_btn_links(@object, "index")

    assert_equal links, nil
  end

  test "page_btn_links should return nil for unexpected action" do
    links = page_btn_links(@object, "123abc")

    assert_equal links, nil
  end

  # Tests for page_title function
  test "page_title should return correct title for 'index' action" do
    self.stubs(:action_name).returns("index")
    title = page_title(@object.class)

    assert_equal "Customers", title
  end

  test "page_title should return correct title for 'edit' action" do
    self.stubs(:action_name).returns("edit")
    title = page_title(@object)

    assert_equal "Editing customer", title
  end

  test "page_title should return correct title for 'new' action" do
    self.stubs(:action_name).returns("new")
    title = page_title(@object)

    assert_equal "New customer", title
  end

  test "page_title should return nil for 'show' action" do
    self.stubs(:action_name).returns("show")
    title = page_title(@object)

    assert_equal nil, title
  end

  test "page_title should return nil for 'delete' action" do
    self.stubs(:action_name).returns("delete")
    title = page_title(@object)

    assert_equal nil, title
  end

  test "page_title should return nil for unexpected action" do
    self.stubs(:action_name).returns("123abc")
    title = page_title(@object)

    assert_equal nil, title
  end
end
