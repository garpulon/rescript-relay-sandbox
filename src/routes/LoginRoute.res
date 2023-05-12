module Query = %relay(`
  query LoginRouteQuery {
    ...StandardLayout_query
    ...LoginPage_query
  }
`)

@react.component
let make = () => {
  let data = Query.use(~variables=(), ())
  let fragmentRefs = data.fragmentRefs

  <StandardLayout fragmentRefs>
    <React.Suspense fallback={<Spinner />}>
      <LoginPage fragmentRefs />
    </React.Suspense>
  </StandardLayout>
}
