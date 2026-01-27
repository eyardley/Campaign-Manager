class PlayerCharactersController < ApplicationController
    before_action :set_campaign, only: %i[ show new create edit update destroy]
    before_action :set_pc, only: %i[ show edit update destroy]

    def show
    end

    def new
        @campaign = Campaign.find(params[:campaign_id])
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
        params.expect(player_character: [:name])
    end

end
