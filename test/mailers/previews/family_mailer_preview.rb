# Preview all emails at http://localhost:3000/rails/mailers/family_mailer
class FamilyMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/family_mailer/send_invitation
  def send_invitation
    FamilyMailer.send_invitation
  end

end
