class CustomersController < ApplicationController
  include CustomersHelper
  include NoticeHelper
  include Shared::IndexHelper

  SEARCHABLE_FIELDS = [:first_name, :last_name, :email]

  before_action :set_customer, only: [:edit, :update, :show, :delete, :destroy]
  before_action :authorize_customer_owner, only: [:edit, :update, :show, :delete, :destroy]

  def index
    @objects = params[:query].present? ? search_objects(
      Customer, SEARCHABLE_FIELDS, params[:query]
    ) : load_index_objects(Customer)
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)
    @customer.user = Current.user

    respond_to do |format|
      if @customer.save
        format.turbo_stream do
          if request.headers["Turbo-Frame"]
            render turbo_stream: turbo_stream.append(
              "car_customer_id",
              html: customer_dropdown_option(@customer),
            )
          else
            redirect_to customers_path, notice: notice_msg(@customer, :created)
          end
        end
        format.html { redirect_to customers_path, notice: notice_msg(@customer, :created) }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @customer.update(customer_params)
      redirect_to customers_path, notice: notice_msg(@customer, :updated)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
  end

  def delete
  end

  def destroy
    @customer.destroy
    redirect_to customers_path, notice: notice_msg(@customer, :deleted)
  end

  private

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :phone, :notes, :user_id)
  end

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def authorize_customer_owner
    unless @customer.user == Current.user
      redirect_to root_path, alert: "You are not authorized to access this customer."
    end
  end
end
