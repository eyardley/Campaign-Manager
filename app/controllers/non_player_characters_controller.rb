class NonPlayerCharactersController < ApplicationController
    before_action :set_campaign
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
        @is_game_master = @campaign.user_id == Current.user.id
    end

    def set_npc
        @npc = NonPlayerCharacter.find(params[:id])
    end

    def npc_params
        params.expect(non_player_character: [:name, :description, :notes, :featured_image, :location_ids])
    end

    def associate_locations(npc)
        locations = params[:non_player_character][:locations]
                    .filter {|location_id| location_id != ""}
                    .map {|location_id| Location.find(location_id)}
        locations.each do |location|
            if !npc.locations.include? location
                npc.locations << location
            end
        end

    end

end
