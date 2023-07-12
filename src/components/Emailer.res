module QueryFragment = %relay(`
  fragment Emailer_query on Query {
    currentUser {
      email
    }
  }
`)

@react.component
let make = (~fragmentRefs) => {
  let data = QueryFragment.use(fragmentRefs)

  switch data.currentUser {
  | Some(currentUser) =>
    <div>
      <h1> {`Hi ${currentUser.email}!`->React.string} </h1>
      <p> {`Thanks for using ReasonReact!`->React.string} </p>
    </div>
  | None => <div> {"Not logged in"->React.string} </div>
  }
}
