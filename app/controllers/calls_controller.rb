class CallsController < ApplicationController
  
  def index
    @calls = Call.all
    respond_to do |format|
      format.html
      format.xml { render 'index.xml.builder' }
    end
  end
  
  def conference_michael
    respond_to do |format|
      format.xml { render 'conference_michael.xml.builder' }
    end
  end
  
  def show
    @call = Call.where(:id => params[:id]).first
    respond_to do |format|
      format.html
      format.xml { render :xml => @call }
      format.json { render :json => @call }
    end
  end
  
  # PUT /calls/1
  # PUT /calls/1.json
  def update
    @call = Call.find(params[:id])

    respond_to do |format|
      if @call.update_attributes(params[:call])
        format.html { redirect_to @call, notice: 'Call was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @call.errors, status: :unprocessable_entity }
      end
    end
  end
  
end
