class NonPlayerCharactersController < ApplicationController
    before_action :set_campaign, only: %i[ show new create edit update destroy]
    before_action :set_npc, only: %i[ show edit update destroy]

    def show
    end

    def new
        @npc = NonPlayerCharacter.new
    end

    def create
        @npc = NonPlayerCharacter.new(npc_params)
        @npc.campaign = @campaign

        if @npc.save
            redirect_to campaign_non_player_character_path(@campaign, @npc)
        else
            render :new, status: :unprocessable_entity
        end
    end

    def update
        if @npc.update(npc_params)
            redirect_to campaign_non_player_character_path(@campaign, @npc)
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @npc.destroy
        redirect_to campaign_path(@campaign)
    end

    private

    def set_campaign
        @campaign = Campaign.find(params[:campaign_id])
    end

    def set_npc
        @npc = NonPlayerCharacter.find(params[:id])
    end

    def npc_params
        params.expect(non_player_character: [:name])
    end

end
