class CrimesController < ApplicationController
    #before_action :set_crime, only: [:show, :edit, :update, :destroy]
    before_action :check_login #needed
    authorize_resource

    def index
        @active_crimes = Crime.active.alphabetical.paginate(page: params[:page]).per_page(15)
        @inactive_crimes = Crime.inactive.alphabetical.paginate(page: params[:page]).per_page(15)  
    end

    def show
    end

    def new
        @crime = Crime.new
    end

    def create
        @crime = Crime.new(crime_params)
        if @crime.save
            flash[:notice] = "Successfully added #{@crime.name} to GCPD."
            redirect_to crimes_path
        else
            render action: 'new'
        end
    end

    def edit
    end

    def update
        @crime = Crime.find(params[:id])
        if @crime.update(crime_params)
          flash[:notice] = "Successfully updated unit by #{@crime.name}."
          redirect_to crimes_path
        else
          render action: 'edit'
        end
    end

    def destroy
        @crime = Crime.find(params[:id])
        # @unit.destroy
        # flash[:notice] = "Removed "
        # redirect_to unit_path
        if @crime.destroy
            flash[:notice] = "Removed #{@crime.name} from the system."
            redirect_to crimes_path
        else
            render action: 'index'
        end
    end

    private
    def crime_params
        params.require(:crime).permit(:name, :active)
    end
end