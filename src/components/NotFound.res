@react.component
let make = () =>
  <Main>
    <h1> {`Page not found!`->React.string} </h1>
    <p>
      <Link to="/"> {`Return home`->React.string} </Link>
    </p>
  </Main>
