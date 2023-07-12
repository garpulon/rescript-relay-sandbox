type payload = Sendgrid.singleRecipientMessage
let task = async (payload: payload) => {
  try {
    let _ = await Sendgrid.getClient->Sendgrid.sendSingle(payload)
  } catch {
  | Js.Exn.Error(obj) => Js.Console.log(obj)
  }
}

let default = task
