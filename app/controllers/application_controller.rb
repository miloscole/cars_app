class ApplicationController < ActionController::Base
  before_action :set_current_user
  before_action :protect_pages

  rescue_from ActiveRecord::RecordNotFound, with: :handle_404

  def handle_404
    render file: "#{Rails.root}/public/404.html", layout: false
  end

  private

  def set_current_user
    Current.user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def protect_pages
    redirect_to new_session_path unless Current.user
  end

  def search_objects(model, searchable_fields, query)
    user_objects = model.where(user_id: Current.user.id)
    user_objects.where(
      searchable_fields.map { |field| "#{model.arel_table.name}.#{field} LIKE :query" }.join(" OR "),
      query: "%#{query}%",
    )
  end
end
