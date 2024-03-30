class UnitsController < ApplicationController
    before_action :set_unit, only: [:show, :edit, :update, :destroy]
    before_action :check_login
    authorize_resource
    
    def index
        @active_units = Unit.active.alphabetical.paginate(page: params[:page]).per_page(15)
        @inactive_units = Unit.inactive.alphabetical.paginate(page: params[:page]).per_page(15)  
    end

    def show
        @current_officers = @unit.officers.alphabetical.active.to_a
    end

    def new
        @unit = Unit.new
    end

    def create
        @unit = Unit.new(unit_params)
        if @unit.save
            flash[:notice] = "Successfully added unit."
            redirect_to @unit
        else
            render action: 'new'
        end
    end

    def edit
    end

    def update
        if @unit.update(unit_params)
          flash[:notice] = "Successfully updated unit by #{@unit.name}."
          redirect_to @unit
        else
          render action: 'edit'
        end
    end
end
