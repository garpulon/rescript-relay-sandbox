module QueryFragment = %relay(`
  fragment RegisterPage_query on Query {
    id
  }
`)

@react.component
let make = (~fragmentRefs) => {
  let query = QueryFragment.use(fragmentRefs)

  React.null
}
