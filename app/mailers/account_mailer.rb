class AccountMailer < ApplicationMailer
  def pin_confirmation(req)
    @req = req
    mail to: req[:email], subject: "Temporary Code"
  end
end
