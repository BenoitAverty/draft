use "net/http"
use l="logger"
use "promises"
use "collections"
use "inspect"

actor Http
  let _client: HTTPClient
  let _logger: l.Logger[String]

  new create(auth: AmbientAuth, logger: l.Logger[String]) =>
    _client = HTTPClient.create(auth)
    _logger = logger

  be get(url: URL, promise: Promise[HttpResponse]) =>
    let request = Payload.request("GET", url)
    request("Host") = "localhost"
    request("Accept") = "*/*"

    try
      _client(consume request, {(session: HTTPSession): _ResponseHandler => _ResponseHandler(session, promise, _logger)} val)?
    else
      _logger(l.Error) and _logger.log("Could not perform request.")
      promise.reject()
    end



class _ResponseHandler is HTTPHandler
  let _logger: l.Logger[String]

  // The http session that this hadler is tied to
  let _session: HTTPSession tag

  // Components of the response. They are not received at the same time.
  var _headers: Map[String, String] val
  var _status: (U16 | None)
  var _body: String trn

  // The promise which will receive the completed response.
  let _promise: Promise[HttpResponse]

  new create(session: HTTPSession tag, promise: Promise[HttpResponse], logger: l.Logger[String]) =>
    _session = session
    _promise = promise
    _logger = logger
    _headers = recover val Map[String, String] end
    _status = None
    _body = recover trn String end

  fun ref apply(payload: Payload val) =>
    _headers = payload.headers()
    _status = payload.status

    _logger.log(Inspect(_status))
    match _status
    | 0 =>
      _logger(l.Error) and _logger.log("Network error.")
      _promise.reject()
    end

    try
      for data in payload.body()?.values() do
        _body.append(data)
      end
    end

  fun ref chunk(data: ByteSeq) =>
    _body.append(data)

  fun ref finished() =>
    try
      _promise(HttpResponse.create(_status as U16, _headers, _body = recover trn String end))
    else
      _promise.reject()
    end

  fun ref cancelled() => _promise.reject()
