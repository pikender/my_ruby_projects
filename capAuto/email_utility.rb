require 'tlsmail'
require 'time'



module Wework
  class Email
    attr_accessor :gmail_uname, :gmail_pwd, :from_em, :to_em, :subj, :bod

    def initialize(gmail_uname, gmail_pwd, from_em, to_em, subj, bod)
      @gmail_uname = gmail_uname
      @gmail_pwd = gmail_pwd
      @from_em = from_em
      @to_em = to_em
      @subj = subj
      @bod = bod
    end

    def mail_content
      content = <<-EOF
        From: #{from_em}
        To: #{to_em}
        Subject: #{subj}
        Date: #{Time.now.rfc2822}

        #{bod}
      EOF
      content
    end

    def deliver_mail
      Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
      Net::SMTP.start('smtp.gmail.com', 587, 'gmail.com', gmail_uname, gmail_pwd, :login) do |smtp|
        smtp.send_message(mail_content, from_em, to_em)
      end
    end
  end
end
