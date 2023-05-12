module Query = %relay(`
  query ForumRouteQuery($slug: String!) {
    ...StandardLayout_query
    ...ForumPage_query @arguments(slug: $slug)
  }
`)

@react.component
let make = (~slug) => {
  let data = Query.use(~variables={slug: slug}, ())
  let fragmentRefs = data.fragmentRefs

  <StandardLayout fragmentRefs>
    <React.Suspense fallback={<Spinner />}>
      <ForumPage fragmentRefs />
    </React.Suspense>
  </StandardLayout>
}
