module Query = %relay(`
  query RegisterRouteQuery {
    ...StandardLayout_query
    ...RegisterPage_query
  }
`)

@react.component
let make = () => {
  let data = Query.use(~variables=(), ())
  let fragmentRefs = data.fragmentRefs

  <StandardLayout fragmentRefs>
    <React.Suspense fallback={<Spinner />}>
      <RegisterPage />
    </React.Suspense>
  </StandardLayout>
}
