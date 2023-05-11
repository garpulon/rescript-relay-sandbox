module Query = %relay(`
  query HomeQuery {
    query {
      forums(first: 50) {
        nodes {
          id
          ...ForumItem_forum
        }
      }
    }
  }
`)

@react.component
let make = () => {
  let data = Query.use(~variables=(), ())

  switch data.query.forums {
  | Some(forums) =>
    forums.nodes
    ->Array.map(forum => <ForumItem key={forum.id} forum={forum.fragmentRefs} />)
    ->React.array
  | None => <h1> {`merp`->React.string} </h1>
  }
}
