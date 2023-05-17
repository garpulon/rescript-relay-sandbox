module PostFragment = %relay(`
  fragment PostItem_post on Post {
    id
    body
    createdAt
    authorId
    user: author {
      email
      avatarUrl
    }
  }
`)

@react.component
let make = (~post) => {
  let post = PostFragment.use(post)

  <article key=post.id className="PostItem">
    {
      let (avatarUrl, userName) = (
        switch post.user {
        | Some({avatarUrl: Some(avatarUrl)}) => avatarUrl
        | _ => Common.avatarImgFallback
        },
        switch post.user {
        | Some({email}) => email
        | _ => `User ${post.authorId}`
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
