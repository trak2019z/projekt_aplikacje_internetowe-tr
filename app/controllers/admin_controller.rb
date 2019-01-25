class AdminController < ApplicationController
  layout 'admin'

  def index
    if !employee_signed_in?
      redirect_to action: 'login'
    end

    # @se = ServiceVisit.select('COUNT(`service_id`) as ilosc,employees.first_name, employees.last_name').joins(:employee).group(:employee_id);
    # @se = @se.collect{|s| [s.last_name+' '+s.first_name, s.ilosc]}
    # @se = [['Pracownik','Ilość usług']] + @se
    # @se = @se.to_json
  end

  def login
    if employee_signed_in?
      redirect_to action: 'index'
    else
      render 'devise/sessions/new'
    end
  end

  def cron

    visits = Visit.select('"visits".*,"clients"."email" as "mail","clients"."phone_number"').joins(:client).where('"visits"."sms" = "t" or "visits"."email" = "t"' ).where('"visits"."status" = "f"').all

    send_time = DateTime.now

    visits.each do |v|

      send_time = (v.start_time - 2.days).change(:hour => 10)

      if v.sms and !v.sms_time? and send_time < DateTime.now

        v.update(:sms_time => send_time)

        Net::HTTP::post_form(URI.parse("http://api.smsapi.pl/sms.do"),{
            "username"=>"o9710786@nwytg.net",
            "password" => "ZGzlbGDE5GOl78qCUuV8mDt62kRwdA75f28UasLS",
            "to"=>v.phone_number,
            "message"=>"Przypominamy o wizycie z dnia " +v.start_time.strftime("%d.%m.%Y")+" o godzinie "+v.start_time.strftime("%H:%M"),
            "from"=>"Eco"
        })

      end

      if v.email and !v.email_time and send_time < DateTime.now

        v.update(:email_time => send_time)

        ClientMailer.send_mail(v.mail,'Przypomnienie o wizycie',"Witaj! Przypominamy o wizycie z dnia " +v.start_time.strftime("%d.%m.%Y")+" o godzinie "+v.start_time.strftime("%H:%M")).deliver

      end

    end


    render nothing: true

  end
end
