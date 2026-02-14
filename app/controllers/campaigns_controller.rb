class CampaignsController < ApplicationController
    before_action :set_campaign, only: %i[ show edit update destroy]
    before_action :validate_user, only: %i[ show ]
    before_action :validate_game_master, only: %i[ edit update destroy ]

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
        @campaign.user_id = Current.user.id
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
        @is_game_master = @campaign.user_id == Current.user.id
        print @is_game_master
    end

    def validate_user
        @campaign = Campaign.find(params[:id])
        if !@campaign.users.include? Current.user 
            redirect_to campaigns_path
        end
        @is_game_master = @campaign.user_id == Current.user.id
    end

    def validate_game_master
        @campaign = Campaign.find(params[:id])
        if !@campaign.user_id == Current.user
            redirect_to campaigns_path
        end
    end


    def campaign_params
        params.expect(campaign: [:name, :description, :notes, :featured_image])
    end

end
