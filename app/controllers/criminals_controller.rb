class CriminalsController < ApplicationController
    before_action :set_criminal, only: [:show, :edit, :update, :destroy]
    before_action :check_login #needed
    authorize_resource
    
    def index
        @criminals = Criminal.alphabetical.paginate(page: params[:page]).per_page(15)
        @enhanced_powers = Criminal.enhanced.alphabetical.paginate(page: params[:page]).per_page(15)  
    end

    def show
        @suspects = @criminal.suspects.alphabetical.to_a
    end

    def new
        @criminal = Criminal.new
    end

    def create
        @criminal = Criminal.new(criminal_params)
        if @criminal.save
            flash[:notice] = "Successfully added #{@criminal.proper_name} to GCPD."
            redirect_to @criminal
        else
            render action: 'new'
        end
    end

    def edit
        @criminal = Criminal.find(params[:id])
    end

    def update
        @criminal = Criminal.find(params[:id])
        if @criminal.update(criminal_params)
          flash[:notice] = "Successfully updated unit by #{@criminal.proper_name}."
          redirect_to @criminal
        else
          render action: 'edit'
        end
    end

    def destroy
        @criminal = Criminal.find(params[:id])
        # @criminal.destroy
        # flash[:notice] = "Removed "
        # redirect_to unit_path
        if @criminal.destroy
            flash[:notice] = "Removed #{@criminal.proper_name} from the system."
            redirect_to criminals_path
        else
            # render action: 'index'
        end
    end

    private
    def set_criminal
        @criminal = Criminal.find(params[:id])
    end

    def criminal_params
        params.require(:criminal).permit(:first_name, :last_name, :aka, :convicted_felon, :enhanced_powers)
    end
end
