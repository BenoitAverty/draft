use "net/http"
use "collections"

class val HttpResponse
  let _status: Status
  let _headers: Map[String, String] val
  let _payload: String

  new val create(status: Status, headers: Map[String, String] val, payload: String) =>
    _status = status
    _headers = headers
    _payload = payload

  fun string(): String val =>
    _status().string() + "\n" + _payload
