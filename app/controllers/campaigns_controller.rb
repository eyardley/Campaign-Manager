class CampaignsController < ApplicationController
    before_action :set_campaign, only: %i[ show edit update destroy]
    before_action :validate_user, only: %i[ show edit]

    def index
        @campaigns = Current.user.campaigns.all
    end

    def show
    end

    def new
        @campaign = Campaign.new
    end

    def create
        @campaign = Campaign.new(campaign_params)
        @campaign.users << Current.user
        if @campaign.save
            redirect_to @campaign
        else
            render :new, status: :unprocessable_entity
        end
    end
    
    def edit
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

    def validate_user
        @campaign = Campaign.find(params[:id])
        if !@campaign.users.include? Current.user 
            redirect_to campaigns_path
        end
    end

    def campaign_params
        params.expect(campaign: [:name])
    end

end
