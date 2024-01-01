class CustomersController < ApplicationController
  include CustomersHelper
  include NoticeHelper
  include Shared::IndexHelper

  SEARCHABLE_FIELDS = [:first_name, :last_name, :email]

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
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])

    if @customer.update(customer_params)
      redirect_to customers_path, notice: notice_msg(@customer, :updated)
    else
      render :edit
    end
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def delete
    @customer = Customer.find(params[:id])
  end

  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy
    redirect_to customers_path, notice: notice_msg(@customer, :deleted)
  end

  private

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :phone, :notes)
  end
end
