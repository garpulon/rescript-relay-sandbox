@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()

  switch url.path {
  //  | list{"user", id} => <User id />
  | list{} => <Home />
  | list{"forums", slug} => <Forum slug />
  | _ => <h1> {"Not found"->React.string} </h1>
  }
}
