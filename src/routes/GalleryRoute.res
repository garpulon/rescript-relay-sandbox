module Query = %relay(`
  query GalleryRouteQuery {
    ...StandardLayout_query
  }
`)

@react.component
let make = () => {
  let data = Query.use(~variables=(), ())
  let fragmentRefs = data.fragmentRefs

  <StandardLayout fragmentRefs>
    <React.Suspense fallback={<Spinner />}>
      <GalleryPage />
    </React.Suspense>
  </StandardLayout>
}
