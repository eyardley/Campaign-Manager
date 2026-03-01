class LocationsController < ApplicationController
    before_action :set_campaign
    before_action :set_location, only: %i[ show edit update destroy ]

    def show
    end

    def new
        @campaign = Campaign.find(params[:campaign_id])
        @location = Location.new
    end

    def create
        @location = Location.new(location_params)
        @location.campaign = @campaign

        if @location.save
            redirect_to campaign_location_path(@campaign, @location)
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @location.update(location_params)
            redirect_to campaign_location_path(@campaign, @location)
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @location.destroy
        redirect_to campaign_path(@campaign)
    end

    private

    def set_campaign
        @campaign = Campaign.find(params[:campaign_id])
        @is_game_master = @campaign.game_master_id == Current.user.id
    end

    def set_location
        @location = Location.find(params[:id])
    end

    def location_params
        params.expect(location: [:name, :description, :notes, :featured_image, related_npc_ids: [], related_location_ids: []])
    end
end
