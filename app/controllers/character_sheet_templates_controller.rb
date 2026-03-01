class CharacterSheetTemplatesController < ApplicationController
    before_action :set_campaign
    before_action :set_template, only: %i[ show edit update destroy ]

    def show
    end

    def new
        @template = CharacterSheetTemplate.new
    end

    def create
        @template = CharacterSheetTemplate.new(template_params)
        @template.campaign = @campaign
        if @template.save
            redirect_to campaign_character_sheet_template_path(@campaign, @template)
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @template.update(template_params)
            redirect_to campaign_character_sheet_template_path(@campaign, @template)
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @template.destroy
        redirect_to campaign_path(@campaign)
    end

    private

    def set_campaign
        @campaign = Campaign.find(params[:campaign_id])
        @is_game_master = @campaign.game_master_id == Current.user.id
    end

    def set_template
        @template = CharacterSheetTemplate.find(params[:id])
    end

    def template_params
        permitted = params.expect(character_sheet_template: [:name, :data])
        permitted[:sheet_type] = 'custom'
        permitted[:data] = JSON.parse(permitted[:data]) if permitted[:data].is_a?(String)
        permitted
    end
end
