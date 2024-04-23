class CustomersController < ApplicationController
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
            success_msg with: @customer.full_name
            redirect_to customers_path
          end
        end
        format.html {
          success_msg with: @customer.full_name
          redirect_to customers_path
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
      success_msg with: @customer.full_name
      redirect_to customers_path
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
    success_msg with: @customer.full_name
    redirect_to customers_path
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
      error_msg :not_authorized
      redirect_to root_path
    end
  end
end
