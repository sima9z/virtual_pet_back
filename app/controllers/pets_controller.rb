class PetsController < ApplicationController
  skip_before_action :require_login, only: [:check_pets, :pet_info, :pet_details]

  def check_pets
    pets_exist = current_user.present? && ( current_user.dog.present? || current_user.cat.present? )
    Rails.logger.debug "Pets exist: #{pets_exist}"
    render json: { pets_exist: pets_exist }
  end

  def pet_info
    if current_user.dog.present?
      pet_type = 'dog'
      offspring_count = current_user.dog.offspring_count || 0
    elsif current_user.cat.present?
      pet_type = 'cat'
      offspring_count = current_user.cat.offspring_count || 0
    else
      pet_type = 'none'
      offspring_count = 0
    end
  
    render json: { petType: pet_type, offspringCount: offspring_count }
  end

  def pet_details
    pet = if current_user.dog.present?
            current_user.dog
          elsif current_user.cat.present?
            current_user.cat
          else
            nil
          end

    if pet
      render json: {
        id: pet.id,
        name: pet.name,
        breed: pet.breed,
        level: pet.level,
        experience: pet.experience,
        physical:pet.physical,
        satiety: pet.satiety,
        happiness: pet.happiness,
        states: pet.states,
        offspring_count: pet.offspring_count
      }
    else
      render json: { error: 'No pet found' }, status: :not_found
    end
  end

  def pet_physical_recover
    pet = if current_user.dog.present?
            current_user.dog
          elsif current_user.cat.present?
            current_user.cat
          else
            nil
          end

    pet.physical += recovery_amount
    pet.physical = [pet.physical, max_physical].min
    pet.save
    render json: { physical: pet.physical }
  end
end