class FamilyMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.family_mailer.send_invitation.subject
  #
  def send_invitation(req)
    @req = req

    mail to: req[:email], subject: req[:subject]
  end
end
