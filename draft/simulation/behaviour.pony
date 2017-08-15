type Behaviour is Array[(Request|WaitingPeriod)] 

class val WaitingPeriod
  let _duration: U64

  new val create(duration': U64) => _duration = duration'

  fun duration(): U64 => _duration

class val Request
  let _method: String
  let _path: String

  new val create(method': String, path': String) =>
    _method = method'
    _path = path'

  fun path(): String => _path

  fun method(): String => _method
