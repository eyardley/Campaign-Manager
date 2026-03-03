class NonPlayerCharactersController < ApplicationController
    include CampaignAuthorization

    before_action :set_campaign
    before_action :set_is_game_master, only: %i[ show ]
    before_action :require_user_belongs_to_campaign , only: %i[ show ]
    before_action :require_game_master, only: %i[ new create edit update destroy ]
    before_action :set_npc, only: %i[ show edit update destroy ]

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
        params.expect(non_player_character: [:name, :description, :notes, :featured_image, related_npc_ids: [], related_location_ids: []])
    end
end
