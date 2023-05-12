module UserFragment = %relay(`
  fragment LoginPage_query on Query {
    currentUser {
      id
    }
  }
`)

@react.component
let make = (~fragmentRefs) => {
  let user = UserFragment.use(fragmentRefs)

  React.null
}
