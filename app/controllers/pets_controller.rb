class PetsController < ApplicationController
  skip_before_action :require_login

  def check_pets
    pets_exist = current_user.present? && (current_user.dog.present? || current_user.cat.present?)
    render json: { pets_exist: pets_exist }
  end
end