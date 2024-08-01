class PetsController < ApplicationController
  skip_before_action :require_login, only: [:check_pets]

  def check_pets
    pets_exist = current_user.present? && ( current_user.dog.present? || current_user.cat.present? )
    Rails.logger.debug "Pets exist: #{pets_exist}"
    render json: { pets_exist: pets_exist }
  end

  def pet_info
    pet_type = if current_user.dog.present?
                 'dog'
               elsif current_user.cat.present?
                 'cat'
               else
                 'none'
               end
    render json: { petType: pet_type }
  end
end