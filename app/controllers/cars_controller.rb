class CarsController < ApplicationController
  before_action :set_car, only: [:edit, :update, :delete, :destroy]
  before_action :authorize_car_owner, only: [:edit, :update, :delete, :destroy]

  def index
    @cars = params[:query].present? ? Car.search(params[:query], params[:page]) : Car.load_all(params[:page])
  end

  def new
    @car = Car.new
  end

  def create
    @car = Car.new(car_params)
    @car.user = Current.user
    if @car.save
      success_msg with: @car.full_name
      redirect_to cars_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @car.update(car_params)
      success_msg with: @car.full_name
      redirect_to cars_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @car = Car.load_for_show(params[:id])
    authorize_car_owner
  end

  def delete
  end

  def destroy
    @car.destroy
    success_msg with: @car.full_name
    redirect_to cars_path
  end

  private

  def car_params
    params.require(:car).permit(
      :brand,
      :model,
      :production_year,
      :price,
      :customer_id,
      :user_id,
      engine_attributes: [:id, :fuel_type, :displacement, :power, :cylinders_num],
    )
  end

  def set_car
    @car = Car.find_by(id: params[:id])
  end

  def authorize_car_owner
    unless @car&.user == Current.user
      error_msg :not_authorized
      redirect_to root_path
    end
  end
end
