module Query = %relay(`
  query EmailEditorQuery($templateId: String!) {
    emailTemplate(templateId: $templateId) {
      plaintextTemplate
      updatedAt
      lastEditedByUser
    }
  }
`)

module UpdateEmailTemplateMutation = %relay(`
  mutation EmailEditor_UpdateEmailTemplateMutation(
    $input: UpdateEmailTemplateInput!
  ) {
    updateEmailTemplate(input: $input) {
      emailTemplate {
        plaintextTemplate
        updatedAt
        lastEditedByUser
      }
      messages {
        message
      }
    }
  }
`)

@react.component
let make = (~templateId) => {
  let data = Query.use(~variables={templateId: templateId}, ())
  let (emailText, setEmailText) = React.useState(() => "")
  let (success, setSuccess) = React.useState(() => false)
  let (error, setError) = React.useState(() => "")

  React.useEffect1(() => {
    switch data.emailTemplate {
    | Some({plaintextTemplate}) => setEmailText(_ => plaintextTemplate)
    | None => setEmailText(_ => "")
    }
    None
  }, [data])

  let (mutate, isMutating) = UpdateEmailTemplateMutation.use()

  switch data.emailTemplate {
  | Some({plaintextTemplate, updatedAt, lastEditedByUser}) =>
    <form
      onSubmit={e => {
        e->ReactEvent.Form.preventDefault
        let _ = mutate(
          ~variables={
            input: RelaySchemaAssets_graphql.make_UpdateEmailTemplateInput(
              ~templateId,
              ~patch={
                templateId: None,
                plaintextTemplate: Some(emailText),
                updatedAt: None,
                lastEditedByUser: None,
                subjectTemplate: None,
                htmlTemplate: None,
                senderEmail: None,
              },
              (),
            ),
          },
          ~onCompleted=(resp, err) => {
            if err == None {
              switch resp.updateEmailTemplate {
              | Some({emailTemplate: Some({plaintextTemplate, lastEditedByUser, updatedAt})}) => {
                  Js.Console.log("Email sent")
                  setSuccess(_ => true)
                  let _ = Js.Global.setTimeout(() => setSuccess(_ => false), 3000)
                }
              | Some({messages: Some([Some({message})])}) => setError(_ => message)
              | _ => ()
              }
            } else {
              Js.Console.log(err)
            }
          },
          ~onError=err => {
            Js.Console.log(err)
          },
          (),
        )
      }}>
      <textarea
        rows=10
        cols=40
        value=emailText
        onChange={e => setEmailText(_ => ReactEvent.Form.target(e)["value"])}
      />
      <p> {`Last edited at ${updatedAt} by ${lastEditedByUser}`->React.string} </p>
      <button type_="submit"> {"Save"->React.string} </button>
      {switch success {
      | true => <p> {"Success!"->React.string} </p>
      | false => React.null
      }}
      {switch error !== "" {
      | true => <p> {error->React.string} </p>
      | false => React.null
      }}
    </form>
  | None => <div />
  }
}
