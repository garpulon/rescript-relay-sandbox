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
  | true =>
    <div style={ReactDOM.Style.make(~display=`grid`, ~gridTemplateColumns="2", ())}>
      <div>
        <CreateNewEmailForm userEmail />
      </div>
      <div style={ReactDOM.Style.make(~gridColumnStart="2", ())}>
        <Emailer fragmentRefs />
      </div>
    </div>
  | false => <div> {`Not authorized`->React.string} </div>
  }
}
