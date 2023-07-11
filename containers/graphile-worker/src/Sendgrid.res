type singleRecipientMessage = {
  to: string,
  from: string,
  subject: string,
  text: string,
  html: string,
}

type sgMail and sgError and sgSuccess
@module external sgMail: sgMail = "@sendgrid/mail"
module Impl = {
  @send external setApiKey: (sgMail, string) => unit = "setApiKey"
}

@send
external sendSingle: (sgMail, singleRecipientMessage) => RescriptCore.Promise.t<sgSuccess> = "send"

sgMail->Impl.setApiKey(%raw(`process.env.SENDGRID_API_KEY`))

let getClient = 
  sgMail

