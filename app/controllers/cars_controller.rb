class CarsController < ApplicationController
  include NoticeHelper
  include CarsHelper

  def index
    @cars = Car.all
  end

  def new
    @car = Car.new
    @car.build_engine
  end

  def create
    @car = Car.new(car_params)

    if @car.save
      redirect_to cars_path, notice: notice_msg(@car, :created)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @car = Car.find(params[:id])
  end

  def update
    @car = Car.find(params[:id])

    if @car.update(car_params)
      redirect_to cars_path, notice: notice_msg(@car, :updated)
    else
      render :edit
    end
  end

  def show
    @car = Car.find(params[:id])
  end

  def delete
    @car = Car.find(params[:id])
  end

  def destroy
    @car = Car.find(params[:id])
    @car.destroy
    redirect_to cars_path, notice: notice_msg(@car, :deleted)
  end

  private

  def car_params
    params.require(:car).permit(
      :name,
      :model,
      :production_year,
      :price,
      :customer_id,
      engine_attributes: [:fuel_type, :displacement, :power, :cylinders_num],
    )
  end
end
