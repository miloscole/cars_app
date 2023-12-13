class CustomersController < ApplicationController
  include NoticeHelper
  include CustomersHelper

  def index
    @customers = (Customer.all).to_a
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      redirect_to(customers_path, notice: created_notice(@customer))
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    puts "Params received: #{params.inspect}"
    @customer = Customer.find(params[:id])
    puts "Customer Params: #{customer_params.inspect}"
    if @customer.update(customer_params)
      redirect_to customers_path, notice: updated_notice(@customer)
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
    redirect_to customers_path, notice: deleted_notice(@customer)
  end

  private

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :phone, :notes)
  end
end
