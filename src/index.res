let _ = Sl.setBasePath("https://cdn.jsdelivr.net/npm/@shoelace-style/shoelace@2.5.2/dist/")

switch ReactDOM.querySelector("#root") {
| Some(rootElement) => {
    let root = ReactDOM.Client.createRoot(rootElement)
    ReactDOM.Client.Root.render(
      root,
      <RescriptRelay.Context.Provider environment=RelayEnv.environment>
        <App />
      </RescriptRelay.Context.Provider>,
    )
  }
| None => ()
}
