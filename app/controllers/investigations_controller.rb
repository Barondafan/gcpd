class InvestigationsController < ApplicationController
    before_action :set_investigation, only: [:show, :edit, :update, :close]
    before_action :check_login #needed
    authorize_resource
    
    def index
        @open_investigations = Investigation.is_open.alphabetical.paginate(page: params[:page]).per_page(15)
        @closed_investigations = Investigation.is_closed.alphabetical.paginate(page: params[:page]).per_page(15)
        @closed_unsolved = Investigation.is_closed.unsolved.alphabetical.paginate(page: params[:page]).per_page(15)
        @with_batman = Investigation.with_batman.alphabetical.paginate(page: params[:page]).per_page(15)
        @unassigned_cases = Investigation.unassigned.alphabetical.paginate(page: params[:page]).per_page(15)
    end

    def show
        @current_assignments = @investigation.assignments.current.by_officer.to_a
    end

    def new
        @investigation = Investigation.new
    end

    def create
        @investigation = Investigation.new(investigation_params)
        if @investigation.save
            flash[:notice] = "Successfully added '#{@investigation.title}' to GCPD."
            redirect_to @investigation
        else
            render action: 'new'
        end
    end

    def edit
        @investigation = Investigation.find(params[:id])
    end

    def update
        @investigation = Investigation.find(params[:id])
        if @investigation.update(investigation_params)
          flash[:notice] = "Successfully updated unit by '#{@investigation.title}'."
          redirect_to @investigation
        else
          render action: 'edit'
        end
    end

    def close
        # @investigation = Investigation.find(params[:id])
        # # @unit.destroy
        # # flash[:notice] = "Removed "
        # # redirect_to unit_path
        # if @investigation.destroy
        #     flash[:notice] = "Removed '#{@investigation.title}' from the system."
        #     redirect_to investigations_path
        # else
        #     render action: 'index'
        # end
        @investigation.close
        redirect_to investigations_path, notice: "Investigation has been closed."

    end

    private
    def set_investigation
        @investigation = Investigation.find(params[:id])
    end

    def investigation_params
        params.require(:investigation).permit(:title, :description, :crime_location, :date_opened, :date_closed, :solved, :batman_involved)
    end
end
