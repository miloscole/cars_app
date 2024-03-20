class Customer < ApplicationRecord
  include RecordOperations

  belongs_to :user
  has_many :cars, dependent: :nullify

  validates :first_name, :last_name, presence: true, length: { minimum: 2, maximum: 25 }
  validates :email, presence: true, uniqueness: true,
                    format: { with: EMAIL_REGEX, message: :invalid }

  FIELDS_TO_LOAD = [
    "customers.id",
    "CONCAT(customers.first_name, ' ', customers.last_name) AS name",
    "customers.email",
    "customers.phone",
    "customers.notes",
  ]

  before_save :downcase_email

  def self.load_all(page)
    load_objects(FIELDS_TO_LOAD, page)
  end

  def self.search(query, page)
    searchable_fields = [:first_name, :last_name, :email]
    search_objects(load_all(page), searchable_fields, query)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def downcase_email
    email.downcase! if email.present?
  end
end
