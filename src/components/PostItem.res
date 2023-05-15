module PostFragment = %relay(`
  fragment PostItem_post on Post {
    id
    body
    createdAt
    authorId
    user: author {
      id
      avatarUrl
      name
    }
  }
`)

@react.component
let make = (~post) => {
  let post = PostFragment.use(post)

  <article className="PostItem">
    {
      let (avatarUrl, userName) = (
        switch post.user {
        | Some({avatarUrl: Some(avatarUrl)}) => avatarUrl
        | _ => Common.avatarImgFallback
        },
        switch post.user {
        | Some({name: Some(userName)}) => userName
        | _ => `User ${post.authorId->Int.toString}`
        },
      )

      <div className="PostItem-meta PostItem-user PostItem-user--with-avatar">
        <img alt="" className="PostItem-avatar" src=avatarUrl />
        {userName->React.string}
      </div>
    }
    <div>
      <time className="PostItem-date"> {post.createdAt->React.string} </time>
      <p className="PostItem-body"> {post.body->React.string} </p>
    </div>
  </article>
}
