module Query = %relay(`
  query NotFoundRouteQuery {
    ...StandardLayout_query
  }
`)

@react.component
let make = () => {
  let data = Query.use(~variables=(), ())
  let fragmentRefs = data.fragmentRefs

  <StandardLayout fragmentRefs>
    <React.Suspense fallback={<Spinner />}>
      <NotFound />
    </React.Suspense>
  </StandardLayout>
}
