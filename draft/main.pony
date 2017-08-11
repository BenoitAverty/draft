use "net/http"
use "httpclient"
use "collections"
use "promises"
use l="logger"

actor Main
  new create(env: Env) =>
    let logger = l.StringLogger(l.Fine, env.out)

    let client = try Http(env.root as AmbientAuth, logger) else return end

    let promise = Promise[HttpResponse]
    promise
      .next[String](
        {(resp: HttpResponse): String => resp.string()} iso,
        {(): String? =>
          logger.log("Rejected promise.")
          error
        } iso
      )
      .next[None]({(str: String) => logger.log(str)} iso)

    let url = try
      URL.build("http://localhost")?
    else
      logger(l.Error) and logger.log("Could not build URL for string http://perdu.com")
      return
    end

    client.get(url, promise)
