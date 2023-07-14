module Query = %relay(`
  query EmailEditorQuery($templateId: String!) {
    emailTemplate(templateId: $templateId) {
      plaintextTemplate
      updatedAt
      lastEditedByUser
    }
  }
`)

@react.component
let make = (~templateId) => {
  Js.Console.log2("beeo", templateId)
  //let x: EmailEditorQuery_graphql.Types.variables = ""
  let data = Query.use(~variables={templateId: templateId}, ())

  switch data.emailTemplate {
  | Some({plaintextTemplate, updatedAt, lastEditedByUser}) =>
    <form>
      <textarea rows=10 cols=40 value=plaintextTemplate />
      <p> {`Last edited at ${updatedAt} by ${lastEditedByUser}`->React.string} </p>
      <button type_="submit"> {"Save"->React.string} </button>
    </form>
  | None => <div />
  }
}
