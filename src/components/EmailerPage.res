module QueryFragment = %relay(`
  fragment EmailerPage_query on Query {
    currentUser {
      isAdmin
      email
    }
  }
`)

@react.component
let make = (~fragmentRefs) => {
  let query = QueryFragment.use(fragmentRefs)
  let (isAdmin, userEmail) = switch query.currentUser {
  | Some({isAdmin, email}) => (isAdmin, Some(email))
  | None => (false, None)
  }

  switch isAdmin {
  | true => <CreateNewEmailForm fragmentRefs userEmail />
  | false => <div> {`Not authorized`->React.string} </div>
  }
}
