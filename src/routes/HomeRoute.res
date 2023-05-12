module Query = %relay(`
  query HomeRouteQuery {
    ...StandardLayout_query
    ...HomePage_query
  }
`)

@react.component
let make = () => {
  let data = Query.use(~variables=(), ())
  let fragmentRefs = data.fragmentRefs

  <StandardLayout fragmentRefs>
    <React.Suspense fallback={<Spinner />}>
      <HomePage fragmentRefs />
    </React.Suspense>
  </StandardLayout>
}
