class PlayerCharactersController < ApplicationController
    include CampaignAuthorization
    include PlayerCharacterAuthorization

    before_action :set_campaign
    before_action :require_user_belongs_to_campaign , only: %i[ new create show ]
    before_action :set_pc, only: %i[ show edit update destroy]
    before_action :set_pc_belongs_to_user, only: %i[ show ]
    before_action :require_pc_belongs_to_user, only: %i[ edit update destroy ]

    def new
        @pc = PlayerCharacter.new
    end

    def create
        @pc = PlayerCharacter.new(pc_params)
        @pc.campaign = @campaign
        @pc.user = Current.user

        if @pc.save
            redirect_to campaign_player_character_path(@campaign, @pc)
        else
            render :new, status: :unprocessable_entity
        end
    end

    def show
      @sheet = @pc.character_sheet
    end

    def edit
    end

    def update
        if @pc.update(pc_params)
            redirect_to campaign_player_character_path(@campaign, @pc)
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @pc.destroy
        redirect_to campaign_path(@campaign)
    end

    private

    def set_campaign
        @campaign = Campaign.find(params[:campaign_id])
    end

    def set_pc
        @pc = PlayerCharacter.find(params[:id])
    end

    def pc_params
        params.expect(player_character: [:name, :description, :notes, :featured_image])
    end

end
