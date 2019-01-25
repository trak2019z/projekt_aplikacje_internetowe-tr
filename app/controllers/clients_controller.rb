class ClientsController < ApplicationController
 
 def edit
    if !client_signed_in?
      redirect_to action: 'login'
    end
    render 'devise/registrations/edit'
  end

  def login
    if client_signed_in?
      render 'homepage/index'
     else
      render 'devise/sessions/new'
    end
  end

  def my_account
    render 'clients/clients'
  end

  def logout
  	destroy_client_session_path
  	#render 'homepage/index'
  end

  def edit_comment
    @services_visits = ServiceVisit.where("client_id = ? AND visit_id = ?", current_client, params[:visit_id])
    render 'visits/edit_comment'
  end

 def update
   @services_visits = ServiceVisit.where("client_id = ? AND visit_id = ?", current_client, params[:visit_id])
   @sv = ServiceVisit.where(:service_id => params[:service_visit][:service_id]).where(:visit_id => params[:visit_id]).first

   if @sv.update(:client_opinion_comment => params[:service_visit][:client_opinion_comment], :client_opinion_rating => params[:service_visit][:client_opinion_rating], :client_opinion_added => params[:service_visit][:client_opinion_added])
     redirect_to action: 'my_account'
   else
     render 'visits/edit_comment'
   end
 end

  def end_visits
    @visits = Visit.where("client_id = ? AND status = ?", current_client, "t")
    render 'visits/end_visits'
  end

 def reserved_visits
   @visits = Visit.where("client_id = ? AND status = ?", current_client, "f")
   render 'visits/reserved_visits'
 end
end
