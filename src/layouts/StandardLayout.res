module Empty = {
  @react.component
  let make = () => <div> {`No bodyComponent provided`->React.string} </div>
}

module QueryFragment = %relay(`
  fragment StandardLayout_query on Query {
    currentUser {
      ...Header_currentUser
    }
  }
`)

@react.component
let make = (~fragmentRefs, ~children) => {
  let fragment = QueryFragment.use(fragmentRefs)

  <React.Suspense fallback={<Spinner />}>
    <div>
      <Header currentUser={fragment.currentUser->Option.map(a => a.fragmentRefs)} />
      {children}
    </div>
  </React.Suspense>
}
