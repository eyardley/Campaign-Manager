class CampaignsController < ApplicationController
    include CampaignAuthorization

    before_action :set_campaign, except: %i[ new create ]
    before_action :set_is_game_master, only: %i[ show ]
    before_action :require_user_belongs_to_campaign , only: %i[ show ]
    before_action :require_game_master, only: %i[ edit update destroy ]

    def new
        @campaign = Campaign.new
    end

    def create
        @campaign = Campaign.new(campaign_params)
        @campaign.users << Current.user
        @campaign.game_master = Current.user
        if @campaign.save
            redirect_to @campaign
        else
            render :new, status: :unprocessable_entity
        end
    end

    def update
        @campaign = Campaign.find(params[:id])
        if @campaign.update(campaign_params)
            redirect_to @campaign
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @campaign.destroy
        redirect_to campaigns_path
    end

    private

    def set_campaign
        @campaign = Campaign.find(params[:id])
    end

    def campaign_params
        params.expect(campaign: [:name, :description, :notes, :featured_image])
    end

end
