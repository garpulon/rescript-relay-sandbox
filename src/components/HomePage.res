module QueryFragment = %relay(`
  fragment HomePage_query on Query {
    forums(first: 50) {
      nodes {
        id
        ...ForumItem_forum
      }
    }
  }
`)

@react.component
let make = (~fragmentRefs) => {
  let fragment = QueryFragment.use(fragmentRefs)

  switch fragment.forums {
  | Some(forums) =>
    forums.nodes
    ->Array.map(({id: key, fragmentRefs}) => <ForumItem key fragmentRefs />)
    ->React.array
  | None => <h1> {`merp`->React.string} </h1>
  }
}
