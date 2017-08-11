use "net/http"
use "collections"

class val HttpResponse
  let _status: U16
  let _headers: Map[String, String] val
  let _payload: String

  new val create(status: U16, headers: Map[String, String] val, payload: String) =>
    _status = status
    _headers = headers
    _payload = payload

  fun string(): String =>
    _status.string() + "\n" + _payload
