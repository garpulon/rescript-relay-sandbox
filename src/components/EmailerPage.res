module QueryFragment = %relay(`
  fragment EmailerPage_query on Query {
    currentUser {
      isAdmin
    }
  }
`)

@react.component
let make = (~fragmentRefs) => {
  let query = QueryFragment.use(fragmentRefs)
  let isAdmin = switch query.currentUser {
  | Some(currentUser) => currentUser.isAdmin
  | None => false
  }

  switch isAdmin {
  | true => <Emailer fragmentRefs />
  | false => <div> {`Not authorized`->React.string} </div>
  }
}
