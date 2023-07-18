module QueryFragment = %relay(`
  fragment HomePage_query on Query {
    forums(first: 50) @connection(key: "HomePage_forums") {
      __id
      edges {
        node {
          id
          ...ForumItem_forum
        }
      }
    }
    ...ForumItem_query
    currentUser {
      isAdmin
    }
  }
`)

@react.component
let make = (~fragmentRefs) => {
  let fragment = QueryFragment.use(fragmentRefs)
  let connectionID = switch fragment.forums {
  | Some({__id}) => Some(__id)
  | _ => None
  }

  let primary = React.useRef(Js.Nullable.null)
  let warning = React.useRef(Js.Nullable.null)

  open Sl.Alert

  let onClickPrimary = _ => {
    primary.current->Js.Nullable.toOption->Belt.Option.forEach(toast)
  }

  let onClickWarning = _ => {
    warning.current->Js.Nullable.toOption->Belt.Option.forEach(toast)
  }

  <Main>
    <h1> {`Welcome`->React.string} </h1>
    <Sl.Button variant={#primary} size={#large} onClick={onClickPrimary}>
      {`Click me`->React.string}
    </Sl.Button>
    <Sl.Alert ref={primary} variant={#primary} closable={true}>
      <Sl.Icon slot="icon" library="default" name="info-circle" />
      {`Hiii`->React.string}
    </Sl.Alert>
    <Sl.Button variant={#warning} size={#large} onClick={onClickWarning}>
      {`Click me`->React.string}
    </Sl.Button>
    <Sl.Alert ref={warning} variant={#warning} duration=3000 closable={true}>
      <Sl.Icon slot="icon" library="default" name="exclamation-triangle" />
      {`Uh oh!`->React.string}
    </Sl.Alert>
    <p className="WelcomeMessage">
      {`Welcome to the PostGraphile forum demo. Here you can see how we have
          harnessed the power of PostGraphile to quickly and easily make a
          simple forum.`->React.string}
      <Link to="https://www.graphile.org/postgraphile/postgresql-schema-design/">
        {`Take a look at the PostGraphile documentation`->React.string}
      </Link>
      {` to see how to get started with your own forum schema design.`->React.string}
    </p>
    <h1> {`Forum List`->React.string} </h1>
    <div className="HomePage-forums">
      {switch fragment.forums {
      | Some(forums) =>
        forums.edges
        ->Array.map(({node: {id: key, fragmentRefs: forum}}) =>
          <ForumItem key forum query=fragment.fragmentRefs />
        )
        ->React.array
      | None =>
        <div>
          {`There are no forums yet!`->React.string}
          {switch fragment.currentUser {
          | Some({isAdmin: true}) => "Create one below..."->React.string
          | Some({isAdmin: false}) => "Please check back later or contact an admin."->React.string
          | None =>
            <span>
              {`Perhaps you need to `->React.string}
              <Link to="/login"> {`log in`->React.string} </Link>
              {`?`->React.string}
            </span>
          }}
        </div>
      }}
    </div>
    {switch fragment.currentUser {
    | Some({isAdmin: true}) =>
      <div>
        <h2> {`Create new forum`->React.string} </h2>
        <p> {`Hello administrator! Would you like to create a new forum?`->React.string} </p>
        <CreateNewForumForm connectionID />
      </div>
    | _ => React.null
    }}
  </Main>
}
