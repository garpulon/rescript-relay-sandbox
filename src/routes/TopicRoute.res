module Query = %relay(`
  query TopicRouteQuery($topic: ID!) {
    ...StandardLayout_query
    ...TopicPage_query @arguments(topic: $topic)
  }
`)

@react.component
let make = (~topic) => {
  let data = Query.use(~variables={topic: topic}, ())
  let fragmentRefs = data.fragmentRefs

  <StandardLayout fragmentRefs>
    <React.Suspense fallback={<Spinner />}>
      <TopicPage fragmentRefs />
    </React.Suspense>
  </StandardLayout>
}
