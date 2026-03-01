class CharacterSheetsController < ApplicationController
  before_action :set_campaign
  before_action :set_pc
  before_action :set_sheet, only: %i[ edit update destroy ]

  def new
      @sheet = CharacterSheet.new
      @sheet.data = @template.to_character_sheet
  end

  def create
      @sheet = CharacterSheet.new(sheet_params)
      if @sheet.save
          redirect_to campaign_player_character_path(@campaign, @pc)
      else
          render :new, status: :unprocessable_entity
      end
  end

  def edit
    @sheet.sync_with_template
  end

  def update
      if @sheet.update(sheet_params)
        redirect_to campaign_player_character_path(@campaign, @pc)
      else
          render :edit, status: :unprocessable_entity
      end
  end

  def destroy
    @sheet.destroy
    redirect_to campaign_player_character_path(@campaign, @pc)
  end

  private

  def set_campaign
    @campaign = Campaign.find(params[:campaign_id])
    set_template @campaign
  end

  def set_template(campaign)
    @template = campaign.character_sheet_template
  end

  def set_pc
    @pc = PlayerCharacter.find(params[:player_character_id])
  end

  def set_sheet
    @sheet = CharacterSheet.find(params[:id])
  end

  def sheet_params
    permitted = params.expect(character_sheet: [:data])
    permitted[:data] = JSON.parse(permitted[:data]) if permitted[:data].is_a?(String)
    permitted[:character_sheet_template_id] = @template.id
    permitted[:player_character_id] = @pc.id
    permitted
  end
end
