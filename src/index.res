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
