class NewAccountMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.new_account_mailer.email_configuration.subject
  #
  def email_configuration(req)
    @req = req

    mail to: req[:email], subject: 'Email Confirmation'
  end
end
