module CurrentUserFragment = %relay(`
  fragment Header_currentUser on User {
    email
    isAdmin
  }
`)

@react.component
let make = (~currentUser) => {
  let currentUser = CurrentUserFragment.useOpt(currentUser)
  <header className="Header">
    <div className="Header-titleContainer">
      <Link to="/">
        //<img src={logo} className="Header-logo" alt="logo" />
        <span className="Header-title"> {`PostGraphile Forum Demo`->React.string} </span>
      </Link>
    </div>
    <div>
      {switch currentUser {
      | Some(currentUser) => {
          let username = currentUser.isAdmin
            ? `${currentUser.email} (administrator)`
            : currentUser.email

          <span>
            {`Logged in as ${username}`->React.string}
            <Link to="/logout"> {`Log out`->React.string} </Link>
            {if currentUser.isAdmin {
              <span>
                {` `->React.string}
                <Link to="/emailer"> {`Emailer`->React.string} </Link>
              </span>
            } else {
              <span />
            }}
          </span>
        }
      | None =>
        <div>
          <Link to="/register"> {`Register`->React.string} </Link>
          <span> {` `->React.string} </span>
          <Link to="/login"> {`Login`->React.string} </Link>
        </div>
      }}
    </div>
  </header>
}
