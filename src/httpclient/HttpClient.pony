use "net/http"
use l="logger"
use "promises"
use "collections"

actor Http
  let _client: HTTPClient
  let _logger: l.Logger[String]

  new create(auth: AmbientAuth, logger: l.Logger[String]) =>
    _client = HTTPClient.create(auth)
    _logger = logger

  be get(url: URL, promise: Promise[HttpResponse]) =>
    promise.apply(HttpResponse.create(StatusOK, recover val Map[String, String].create() end, "Test"))
