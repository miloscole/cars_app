class CarsController < ApplicationController
  include CarsHelper
  include NoticeHelper
  include Shared::IndexHelper

  before_action :set_car, only: [:edit, :update, :delete, :destroy]
  before_action :authorize_car_owner, only: [:edit, :update, :delete, :destroy]

  def index
    @cars = params[:query].present? ? search_cars : load_cars
  end

  def new
    @car = Car.new
  end

  def create
    @car = Car.new(car_params)
    @car.user = Current.user
    if @car.save
      redirect_to cars_path, notice: notice_msg(@car, @car.full_name, :created)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @car.update(car_params)
      redirect_to cars_path, notice: notice_msg(@car, @car.full_name, :updated)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @car = load_car_for_show
    authorize_car_owner
  end

  def delete
  end

  def destroy
    @car.destroy
    redirect_to cars_path, notice: notice_msg(@car, @car.full_name, :deleted)
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
      redirect_to root_path, alert: "You are not authorized to access this car."
    end
  end
end
