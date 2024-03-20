class CustomersController < ApplicationController
  include NoticeHelper

  before_action :set_customer, only: [:edit, :update, :show, :delete, :destroy]
  before_action :authorize_customer_owner, only: [:edit, :update, :show, :delete, :destroy]

  def index
    @customers = params[:query].present? ?
      Customer.search(params[:query], params[:page]) :
      Customer.load_all(params[:page])
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
              html: helpers.customer_dropdown_option(@customer),
            )
          else
            redirect_to customers_path,
                        notice: notice_msg(@customer, @customer.full_name, :created)
          end
        end
        format.html {
          redirect_to customers_path,
                      notice: notice_msg(@customer, @customer.full_name, :created)
        }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @customer.update(customer_params)
      redirect_to customers_path, notice: notice_msg(@customer, @customer.full_name, :updated)
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
    redirect_to customers_path, notice: notice_msg(@customer, @customer.full_name, :deleted)
  end

  private

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :phone, :notes, :user_id)
  end

  def set_customer
    @customer = Customer.find_by(id: params[:id])
  end

  def authorize_customer_owner
    unless @customer&.user == Current.user
      redirect_to root_path, alert: "You are not authorized to access this customer."
    end
  end
end
