class ClientMailer < ApplicationMailer

  def send_mail(email, subject, body)
    mail(to: email,
         body: body,
         from: 'Salon Kosmetyczny',
         content_type: "text/html",
         subject: subject)
  end



end
