class CrimeInvestigationsController < ApplicationController
    # before_action :set_unit, only: [:show, :edit, :update, :destroy]
    before_action :check_login #needed
    authorize_resource
    
    def new
        @crime_investigation = CrimeInvestigation.new
        @investigation = Investigation.find(params[:investigation_id])
        @crimes_list = @investigation.crimes
        # @crime = Crime.find(params[:crime_id])
    end

    def create
        @crime_investigation = CrimeInvestigation.new(crime_investigation_params)
        if @crime_investigation.save
          flash[:notice] = "Successfully added #{@crime_investigation.crime.name} to #{@crime_investigation.investigation.title}."
          redirect_to investigation_path(@crime_investigation.investigation)
        else
          @investigation = Investigation.find(params[:crime_investigation][:investigation_id])
          render action: 'new', locals: { investigation: @investigation }
        end
    end

    def destroy
        @crime_investigation = CrimeInvestigation.find(params[:id])
        @crime_investigation.destroy
        flash[:notice] = "Successfully removed a crime from this investigation."
        redirect_to investigation_path(@crime_investigation.investigation)
    end

    private
    def crime_investigation_params
        params.require(:crime_investigation).permit(:crime_id, :investigation_id)
    end
end
