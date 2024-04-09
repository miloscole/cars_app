module FormConfig
  # By default, text fields are used for input in all forms, as they are the most common type of field in the app.
  # If you need any other type of field, simply add it inside FIELD_TYPES.
  # Each key represents an object attribute name, and its corresponding value represents the type of input field.
  # The render_form_field method will automatically render these fields based on the values provided.
  # Special cases:
  # - For regular_dropdown: Ensure enums are defined in your model for the attributes requiring a dropdown.
  # - For dynamic_dropdown: This dropdown is used for adding associations within forms.
  #   It should load all objects that can be associated with the object being built in the form.
  #   The dropdown includes an "Add New" button to create a new object from the form.
  #   To properly generate "Add new" button, your route for new action should follow Rails convention
  #   (e.g., new_customer_path for customers#new)
  #   Also, there should be a method on the model to load all dropdown objects,
  #   following the naming convention "load_objects".
  #   For example, for the Car model, implement load_customers to load all customers that can be chosen for association.
  # Available special field types: area, date, number, regular_dropdown, dynamic_dropdown.
  SPECIFIC_FIELD_TYPES = {
    "notes" => :area,
    "production_year" => :date,
    "price" => :number,
    "fuel_type" => :regular_dropdown,
    "displacement" => :regular_dropdown,
    "power" => :regular_dropdown,
    "cylinders_num" => :regular_dropdown,
    "customer_id" => :dynamic_dropdown,
  }
end
