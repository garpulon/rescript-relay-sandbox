module Query = %relay(`
  query EmailerRouteQuery {
    ...StandardLayout_query
    ...EmailerPage_query
    ...Emailer_query
  }
`)

@react.component
let make = () => {
  let data = Query.use(~variables=(), ())
  let fragmentRefs = data.fragmentRefs

  <StandardLayout fragmentRefs>
    <React.Suspense fallback={<Spinner />}>
      <EmailerPage fragmentRefs />
    </React.Suspense>
  </StandardLayout>
}
