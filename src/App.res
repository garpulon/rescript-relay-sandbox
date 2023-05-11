module Query = %relay(`
  query AppQuery($slug: String!) {
    query {
      ...StandardLayout_query
      ...Home_query
      ...ForumPage_query @arguments(slug: $slug)
    }
  }
`)

@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()
  let slug = switch url.path {
  | list{"forums", slug} => slug
  | _ => ""
  }

  let data = Query.use(~variables={slug: slug}, ())
  let fragmentRefs = data.query.fragmentRefs

  switch url.path {
  //  | list{"user", id} => <User id />
  | list{} =>
    <StandardLayout fragmentRefs>
      <Home fragmentRefs />
    </StandardLayout>
  | list{"forums", _} =>
    <StandardLayout fragmentRefs>
      <ForumPage fragmentRefs />
    </StandardLayout>
  | _ => <h1> {"Not found"->React.string} </h1>
  }
}
