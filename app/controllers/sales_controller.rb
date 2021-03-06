class SalesController < ApplicationController
  before_action :set_sale, only: [:edit, :update, :destroy]
  before_filter :authenticate_user!
  after_action :verify_authorized

  #Allow all actions, pundit ensures admin user, store current_user as creator

  # GET /sales
  # GET /sales.json
  def index
    @sales = Sale.all
    authorize  @sales
  end


  # GET /sales/new
  def new
    @sale = Sale.new
    authorize  @sale
  end

  # GET /sales/1/edit
  def edit
    authorize  @sale
  end

  # POST /sales
  def create
    @sale = Sale.new(sale_params)
    authorize  @sale
    @sale.user = current_user
    respond_to do |format|
      if @sale.save
        format.html { redirect_to sales_url, notice: 'Sale was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /sales/1
  def update
    authorize  @sale
    @sale.user ||= current_user
    respond_to do |format|
      if @sale.update(sale_params)
        format.html { redirect_to sales_url, notice: 'Sale was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /sales/1
  def destroy
    authorize  @sale
    @sale.destroy
    respond_to do |format|
      format.html { redirect_to sales_url, notice: 'Sale was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale
      @sale = Sale.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sale_params
      params.require(:sale).permit(:start, :end, :quantity)
    end
end
