class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: [:create]

  def create
    user = login(params[:email], params[:password])
    
    if user
      Rails.logger.debug "Logged in user: #{user.inspect}"
      Rails.logger.debug "Session ID: #{session[:user_id]}"
      session[:user_id] = user.id
  
      # 最後のログアウト時刻が記録されている場合、経過時間に基づいて体力を回復
      if user.last_logout_at
        elapsed_time = Time.current - user.last_logout_at
        recovery_amount = calculate_recovery(elapsed_time)
  
        pet = user.dog || user.cat # 飼っているペットが犬か猫か確認
        if pet
          pet.physical += recovery_amount
          pet.physical = [pet.physical, pet.max_physical].min # 体力の最大値を超えないように制限
          pet.save
        end
      end
  
      # 最後のログアウト時刻をリセット（次回ログアウト用に再設定）
      user.update(last_logout_at: nil)
  
      render json: { user: user }, status: :ok
    else
      Rails.logger.debug "Invalid email or password for email: #{params[:email]}"
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
  
  def destroy
    current_user.update(last_logout_at: Time.current)
    Rails.logger.debug "Current user before logout: #{current_user.inspect}"
    logout
    cookies.delete(:remember_token, domain: :all)
    Rails.logger.debug "Current user after logout: #{current_user.inspect}"
    render json: { message: 'Logged out' }, status: :ok
  end

  private

  def calculate_recovery(elapsed_time)
    # 体力回復の計算 (例えば、1分ごとに体力1回復)
    (elapsed_time / 1.minute).floor
  end

end