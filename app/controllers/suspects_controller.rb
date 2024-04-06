class SuspectsController < ApplicationController
    # before_action :set_unit, only: [:show, :edit, :update, :destroy]
    before_action :check_login #needed
    authorize_resource
    
    def new
        @suspect = Suspect.new
        @investigation = Investigation.find(params[:investigation_id])
        @current_suspects = @investigation.suspects.current
    end

    def create
        @suspect = Suspect.new(suspect_params)
        @suspect.added_on = Date.current
        if @suspect.save
          flash[:notice] = "Successfully added suspect."
          redirect_to investigation_path(@suspect.investigation)
        else
          @investigation = Investigation.find(params[:suspect][:investigation_id])
          render action: 'new', locals: { investigation: @investigation }
        end
    end

    def terminate
        @suspect = Suspect.find(params[:id])
        @suspect.dropped_on = Date.current
        @suspect.save
        flash[:notice] = "Successfully terminated suspect."
        redirect_to investigation_path(@suspect.investigation)
    end

    private
    def suspect_params
        params.require(:suspect).permit(:criminal_id, :investigation_id, :added_on)
    end
end
