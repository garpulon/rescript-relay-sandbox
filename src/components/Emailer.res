module QueryFragment = %relay(`
  fragment Emailer_query on Query {
    emailTemplateIds {
      nodes {
        id
        templateId
      }
    }
  }
`)

@react.component
let make = (~fragmentRefs) => {
  let data = QueryFragment.use(fragmentRefs)
  let (selectedId, setSelectedId) = React.useState(() => None)

  let templateIds = switch data.emailTemplateIds {
  | Some({nodes}) => nodes
  | None => []
  }

  let options = templateIds->Belt.Array.map(node => {
    <option key={node.id} value={node.templateId}> {node.templateId->React.string} </option>
  })

  <div>
    <h1> {"Email templates"->React.string} </h1>
    <form>
      <select
        onChange={e =>
          setSelectedId(_ => {
            let v = ReactEvent.Form.target(e)["value"]
            v == "" ? None : Some(v)
          })}>
        <option value=""> {"Select a value"->React.string} </option>
        {React.array(options)}
      </select>
      <br />
      {switch selectedId {
      | Some(templateId) => {
          Js.Console.log(templateId)
          <EmailEditor templateId />
        }
      | None => <div />
      }}
    </form>
  </div>
}
