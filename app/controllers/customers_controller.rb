class CustomersController < ApplicationController
  include NoticeHelper
  include CustomersHelper
  include ERB::Util

  def index
    @customers = Customer.all
  end

  def new
    @customer = Customer.new
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def create
    @customer = Customer.new(customer_params)

    respond_to do |format|
      if @customer.save
        format.turbo_stream do
          render turbo_stream: turbo_stream.append(
            "car_customer_id",
            html: "<option value='#{html_escape(@customer.id)}'>#{html_escape(@customer.full_name)}</option>".html_safe,
          )
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
