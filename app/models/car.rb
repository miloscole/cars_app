class Car < ApplicationRecord
  include RecordOperations

  belongs_to :user
  belongs_to :customer, optional: true
  has_one :engine, dependent: :destroy
  accepts_nested_attributes_for :engine, allow_destroy: true

  validates :brand, :model, :production_year, :price, presence: true
  validate :customer_belongs_to_current_user

  CONCAT_CUS_NAME = "CONCAT(customers.first_name, ' ', customers.last_name) AS customer"
  CONCAT_PRICE = "CONCAT('$', cars.price) AS sale_price"
  FIELDS_TO_LOAD = %W[cars.id cars.brand cars.model cars.production_year #{CONCAT_PRICE} #{CONCAT_CUS_NAME}]
  SELECT_FIELDS = %W[user_id brand model production_year price #{CONCAT_CUS_NAME}]

  def self.load_all(page)
    load_objects(FIELDS_TO_LOAD, page) { |q| q.left_joins(:customer) }
  end

  def self.load_for_show(id)
    select(SELECT_FIELDS).left_joins(:customer).find_by(id: id)
  end

  def self.search(query, page)
    searchable_fields = [:brand, :model]
    search_objects(load_all(page), searchable_fields, query)
  end

  def self.load_customers
    load_customers = Customer.where(user_id: Current.user.id).select("id, first_name, last_name")

    load_customers.map do |customer|
      [customer.full_name, customer.id]
    end
  end

  def full_name
    "#{brand} #{model}"
  end

  private

  def customer_belongs_to_current_user
    if customer.present? && customer.user != Current.user
      errors.add(:customer_id, "must belong to the current user")
    end
  end
end
