module CurrentUserFragment = %relay(`
  fragment Header_currentUser on User {
    id
    name
    isAdmin
  }
`)
module UserBar = {
  @react.component
  let make = (~currentUser) => {
    let currentUser = CurrentUserFragment.useOpt(currentUser)

    switch currentUser {
    | Some(currentUser) => {
        let username = currentUser.name->Option.getWithDefault(`User ${currentUser.id}`)
        let username = currentUser.isAdmin ? `${username} (administrator)` : username

        <span>
          {`Logged in as ${username}`->React.string}
          <Link to="/logout"> {`Log out`->React.string} </Link>
        </span>
      }
    | None => <Link to="/login"> {`Login`->React.string} </Link>
    }
  }
}
module LoginLink = {
  @react.component
  let make = () => <Link to="/login"> {`Login`->React.string} </Link>
}

@react.component
let make = (~currentUser) => {
  <header className="Header">
    <div className="Header-titleContainer">
      <Link to="/">
        //<img src={logo} className="Header-logo" alt="logo" />
        <span className="Header-title"> {`PostGraphile Forum Demo`->React.string} </span>
      </Link>
    </div>
    <div>
      <UserBar currentUser />
      //<div> {this.renderUser()} </div>
    </div>
  </header>
}
