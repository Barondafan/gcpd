class OfficersController < ApplicationController
    before_action :set_officer, only: [:show, :edit, :update, :destroy]
    before_action :check_login #needed
    authorize_resource
    
    def index
        @active_officers = Officer.active.alphabetical.paginate(page: params[:page]).per_page(15)
        @inactive_officers = Officer.inactive.alphabetical.paginate(page: params[:page]).per_page(15)  
    end

    def show
        @current_assignments = @officer.assignments.current.to_a
        @past_assignments = @officer.assignments.past.to_a
    end

    def new
        @officer = Officer.new
    end

    def create
        @officer = Officer.new(officer_params)
        if @officer.save
            flash[:notice] = "Successfully created #{@officer.proper_name}."
            redirect_to @officer
        else
            render action: 'new'
        end
    end

    def edit
        @officer = Officer.find(params[:id])
    end

    def update
        @officer = Officer.find(params[:id])
        if @officer.update(officer_params)
          flash[:notice] = "Successfully updated unit by #{@officer.proper_name}."
          redirect_to @officer
        else
          render action: 'edit'
        end
    end

    def destroy
        @officer = Officer.find(params[:id])
        # @unit.destroy
        # flash[:notice] = "Removed "
        # redirect_to unit_path
        if @officer.destroy
            flash[:notice] = "Removed #{@officer.proper_name} from the system."
            redirect_to officers_path
        else
            render action: 'show'
        end
    end

    private
    def set_officer
        @officer = Officer.find(params[:id])
    end

    def officer_params
        params.require(:officer).permit(:active, :ssn, :rank, :first_name, :last_name, :unit_id, :username, :role, :password, :password_confirmation)
    end
end