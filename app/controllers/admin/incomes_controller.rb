class Admin::IncomesController < ApplicationController

  before_action :require_admin_login

  layout 'admin'

  def require_admin_login
    if !employee_signed_in?
      redirect_to admin_login_url
    end
  end

  def index
                # do poprawki - przejscie z sqlite na postgres sprawilo ze to nie dziala
    @days = Visit.select("start_time,SUM(price) as price").group("start_time").where(:start_time => DateTime.now.beginning_of_month..DateTime.now.end_of_month).where(:status => true).order("start_time DESC").all
    @months = Visit.select("start_time,SUM(price) as price").group("start_time").where(:status => true).order("start_time DESC").all
    @years = Visit.select("start_time,SUM(price) as price").group("start_time").where(:status => true).order("start_time DESC").all
    @total = 0
    @years.collect { |x| @total = @total + x.price }
  end
end
