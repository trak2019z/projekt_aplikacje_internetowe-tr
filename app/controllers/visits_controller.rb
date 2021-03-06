class VisitsController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout 'application'

  def index

    allvisits = Visit.all

    @events = Array.new

    allvisits.each do |v|

      duration = 0

      v.service_visits.each do |s|
        duration += s.service.duration
      end

      c = ''
      if v.status?
        c = ', backgroundColor: "green"'
      end

      @events.push('{
        title: "' + current_client.first_name + ' ' + current_client.last_name + '",
        start: "' + v.start_time.to_time.iso8601 + '",
        end: "' + (v.start_time + duration.minutes).to_time.iso8601 + '"' + c + '
      }')

    end

    @events = @events.join(',')

    if params[:from]
      @from = params[:from]
    else
      @from = Date.today.at_beginning_of_month.strftime("%d.%m.%Y")
    end

    if params[:to]
      @to = params[:to]
    else
      @to = Date.today.at_beginning_of_month.next_month.strftime("%d.%m.%Y")
    end

    @select = 'all'
    if params[:status]
      @select = params[:status]
    end

    fromf = DateTime.parse(@from)
    tof = DateTime.parse(@to).end_of_day

    query = Visit.where(:start_time => fromf..tof).order(:start_time)
    if params[:status] and (params[:status] == 't' or params[:status] == 'f')
      query = query.where(:status => params[:status])
    end

    @select = params[:status]

    @visits = query
    render 'visits/index', :layout => "application"
  end

  def show
    @visit = Visit.find(params[:id])
  end

  def new

    @visit = Visit.new

    @se = Service.all.collect { |s| {:id => s.id, :name => s.name, :price => s.price, :duration => s.duration, :employees => s.employees.all.collect { |x| {:id => x.id, :name => x.last_name+' '+x.first_name} }} }
    @sejson = @se.to_json

      render 'visits/new', :layout => "application"

  end

  def edit
    @visit = Visit.find(params[:id])

    @se = Service.all.collect { |s| {:id => s.id, :name => s.name, :price => s.price, :duration => s.duration, :employees => s.employees.all.collect { |x| {:id => x.id, :name => x.last_name+' '+x.first_name} }} }
    @sejson = @se.to_json

    @services = ServiceVisit.select('*').joins(:service, :employee).where(:visit_id => params[:id]).all.collect { |s| {:employee => s.employee_id, :service => s.service_id, :name => s.name, :duration => s.duration, :price => s.price, :employee_name => s.last_name+' '+s.first_name} }
    @services = @services.to_json

    render 'new'
  end



  def create

    @se = Service.all.collect { |s| {:id => s.id, :name => s.name, :price => s.price, :duration => s.duration, :employees => s.employees.all.collect { |x| {:id => x.id, :name => x.last_name+' '+x.first_name} }} }
    @sejson = @se.to_json

    p = params.require(:visit)

    if p[:services]
      price = Service.where(:id => p[:services].collect { |s| s.split(',')[0] }).sum(:price)
      price = price.to_i
    else
      price = 0
    end


    @visit = Visit.new(
        :client_id => current_client.id,
        :price => price,
        :discount => 0,
        :comments => p[:comments],
        :status => false,
        :start_time => p[:start_time],
        :sms => p[:sms],
        :email => p[:email]
    )

    if @visit.save

      if p[:services]
        p[:services].each do |se|

          s = se.split(',')[0]
          e = se.split(',')[1]

          @sv = ServiceVisit.new(:client_id => p[:client_id], :employee_id => e, :service_id => s, :visit_id => @visit.id, :client_opinion_rating => 1)
          @sv.save


        end
      end

      redirect_to action: 'index'

    else
      render 'new'

    end

  end
end
