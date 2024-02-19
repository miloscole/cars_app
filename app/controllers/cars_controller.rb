class CarsController < ApplicationController
  include NoticeHelper
  include Shared::IndexHelper

  SEARCHABLE_FIELDS = [:name, :model]

  before_action :set_car, only: [:edit, :update, :show, :delete, :destroy]
  before_action :authorize_car_owner, only: [:edit, :update, :show, :delete, :destroy]

  def index
    @cars = params[:query].present? ?
      search_objects(Car, SEARCHABLE_FIELDS, params[:query]) : load_index_objects(Car)
  end

  def new
    @car = Car.new
    @car.build_engine
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
      :name,
      :model,
      :production_year,
      :price,
      :customer_id,
      :user_id,
      engine_attributes: [:id, :fuel_type, :displacement, :power, :cylinders_num],
    )
  end

  def set_car
    @car = Car.find(params[:id])
  end

  def authorize_car_owner
    unless @car.user == Current.user
      redirect_to root_path, alert: "You are not authorized to access this car."
    end
  end
end
