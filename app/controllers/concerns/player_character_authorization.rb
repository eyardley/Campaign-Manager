module PlayerCharacterAuthorization
  extend ActiveSupport::Concern

  private

  def set_pc_belongs_to_user
    @pc_belongs_to_user = @pc.user.id == Current.user.id
  end

  def require_pc_belongs_to_user
    redirect_to campaigns_path unless @pc.user.id == Current.user.id
  end
end
