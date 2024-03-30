class InvestigationsController < ApplicationController
    before_action :set_investigation, only: [:show, :edit, :update, :destroy]
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
        @current_assignments = @investigation.assignments.alphabetical.active.to_a
    end

    def new
        @investigation = Investigation.new
    end

    def create
        @investigation = Investigation.new(investigation_params)
        if @investigation.save
            flash[:notice] = "Successfully added #{@investigation.name} to GCPD."
            redirect_to investigations_path
        else
            render action: 'new'
        end
    end

    def edit
        @investigation = Investigation.find(params[:id])
    end

    def update
        @investigation = Unit.find(params[:id])
        if @unit.update(unit_params)
          flash[:notice] = "Successfully updated unit by #{@unit.name}."
          redirect_to @unit
        else
          render action: 'edit'
        end
    end

    def destroy
        @unit = Unit.find(params[:id])
        # @unit.destroy
        # flash[:notice] = "Removed "
        # redirect_to unit_path
        if @unit.destroy
            flash[:notice] = "Removed #{@unit.name} from the system."
            redirect_to units_path
        else
            render action: 'index'
        end
    end

    private
    def set_unit
        @unit = Unit.find(params[:id])
    end

    def unit_params
        params.require(:unit).permit(:name, :active)
    end
end
