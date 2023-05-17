let avatarImgFallback = "http://placekitten.com/150/150"

module InsecureJWTStorage = {
  open Dom.Storage2
  /*
   * Opinion is divided about JWTs and security, generally.
   *
   * Risks:
   * - Storing tokens in localStorage (or similar) opens you to XSS vulnerabilities
   * - Role claims in JWT tokens cannot be invalidated, as you are the signer.
   * - JWTs, more broadly, cannot be invalidated until they expire
   *
   * Storage Solutions:
   * - set it in a secure cookie a la https://stackoverflow.com/a/52881715
   * - store in a webworker thread a la https://auth0.com/docs/secure/security-guidance/data-security/token-storage#browser-in-memory-scenarios
   *
   * Claim Solutions:
   * - do not store role in claim
   * - store role in claim, but RLS policies check the user id for specific perms, which can include no perms (preferred)
   *
   * Implementation challenges:
   * - Cookie solution requires HTTP middleware or complex postgraphile plugin that's not immediately obvious
   * - Web workers solution does not last across sessions also requires porting to Rescript
   */
  let storageKey = "insecure-sandbox-jwt"
  let set = jwt => localStorage->setItem(storageKey, jwt)
  let get = () => localStorage->getItem(storageKey)
  let delete = () => localStorage->removeItem(storageKey)
}

module URLSearchParams = {
  open RescriptCore
  type t

  @new external parse: string => t = "URLSearchParams"
  @new external make: Dict.t<string> => t = "URLSearchParams"
  let fromArray = a => a->Dict.fromArray |> make

  @send @return(nullable)
  external get: (t, string) => option<string> = "get"

  @send external toString: t => string = "toString"
}
