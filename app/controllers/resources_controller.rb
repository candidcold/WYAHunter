class ResourcesController < ApplicationController
  before_action :set_resource, only: [:show, :edit, :update, :destroy]
  before_action :require_login, only: [:edit, :update]
  before_action :require_admin, only: [:new, :create, :destroy]

  # GET /resources
  # GET /resources.json
  def index
      if params[:resource_type] != nil
        @resources = Resource.where(:resource_type => params[:resource_type])
      else
        @resources = Resource.all
      end
  end

  # GET /resources/1
  # GET /resources/1.json
  def show
  end

  # GET /resources/new
  def new
    @resource = Resource.new
  end

  # GET /resources/1/edit
  def edit
    #   if current_user[:privilege] != params[:id]
    #       redirect_to '/login'
    #   end
  end

  # POST /resources
  # POST /resources.json
  def create
    require_admin

    @resource = Resource.new(resource_params)

    respond_to do |format|
      if @resource.save
        format.html { redirect_to @resource, notice: 'Resource was successfully created.' }
        format.json { render :show, status: :created, location: @resource }
      else
        format.html { render :new }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /resources/1
  # PATCH/PUT /resources/1.json
  def update
    if current_user[:privilege] != params[:id].to_i
        print "Priv and id do not match #{current_user[:privilege]} #{params[:id]}"
        redirect_to '/login'
        return
    end

    respond_to do |format|
      if @resource.update(resource_params)
        format.html { redirect_to @resource, notice: 'Resource was successfully updated.' }
        format.json { render :show, status: :ok, location: @resource }
      else
        format.html { render :edit }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resources/1
  # DELETE /resources/1.json
  def destroy
    @resource.destroy
    respond_to do |format|
      format.html { redirect_to resources_url, notice: 'Resource was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def types
    types = Resource.select("lower (resource_type) as rt").distinct.map { |c| c.rt }
    render :json => types
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resource
      @resource = Resource.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      params.require(:resource).permit(:location, :privilege, :description, :available, :resource_type)
    end
end
