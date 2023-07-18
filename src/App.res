@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()

  <React.Suspense fallback={<Spinner />}>
    {switch url.path {
    //  | list{"user", id} => <User id />
    | list{} => <HomeRoute />
    | list{"forums", slug} => <ForumRoute slug />
    | list{"forums", _, topic} => <TopicRoute topic />
    | list{"login"} => <LoginRoute />
    | list{"register"} => <RegisterRoute />
    | list{"emailer"} => <EmailerRoute />

    | list{"error"} => <ErrorPage urlSearch=url.search />
    | list{"logout"} => {
        Common.InsecureJWTStorage.delete()
        RescriptReactRouter.replace("/")
        let _ = %raw(`location.reload()`)
        React.null
      }
    | _ => <NotFoundRoute />
    }}
  </React.Suspense>
}
