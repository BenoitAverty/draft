use "net/http"
use "httpclient"
use "collections"
use "promises"
use l="logger"

class ToString is Fulfill[HttpResponse, String]
  fun apply(resp: HttpResponse): String => resp.string()

class LogPromise is Fulfill[String, String]
  let _logger: l.Logger[String]

  new create(logger: l.Logger[String]) =>
    _logger = logger

  fun apply(str: String): String =>
    _logger.log(str)
    str

actor Main
  new create(env: Env) =>
    let logger = l.StringLogger(l.Info, env.out)

    let client = try Http(env.root as AmbientAuth, logger)? else return end

    let callback = Promise[HttpResponse]
    callback.next[String](recover ToString end).next[String](recover LogPromise(logger) end)

    logger.log("Done.")

// actor _GetWork
//   let _env: Env
//
//   new create(env: Env) =>
//     _env = env
//
//   be performRequest(url: URL) =>
//
//     try
//
//       let client = HTTPClient.create(_env.root as AmbientAuth)
//       let req = Payload.request("GET", url)
//       req("User-Agent") = "Pony load test tool"
//
//       let printer = recover val NotifyFactory.create(this) end
//
//       try
//         client.apply(consume req, printer)?
//       else
//         _env.out.print("An error occured while sending the request.")
//       end
//     else
//       _env.out.print("Unable to use the network.")
//     end
//
//   be cancelled() =>
//     _env.out.print("-- response cancelled --")
//
//   be have_response(response: Payload val) =>
//     """
//     Process return the the response message.
//     """
//     if response.status == 0 then
//       _env.out.print("Failed")
//       return
//     end
//
//     // Print the status and method
//     _env.out.print(
//       "Response " +
//       response.status.string() + " " +
//       response.method)
//
//     // Print all the headers
//     for (k, v) in response.headers().pairs() do
//       _env.out.print(k + ": " + v)
//     end
//
//     _env.out.print("")
//
//     // Print the body if there is any.  This will fail in Chunked or
//     // Stream transfer modes.
//     try
//       let body = response.body()?
//       for piece in body.values() do
//         _env.out.write(piece)
//       end
//     end
//
//   be have_body(data: ByteSeq val) =>
//     _env.out.write(data)
//
//   be finished() =>
//     _env.out.print("-- end of body --")
//
// class NotifyFactory is HandlerFactory
//   let _main: _GetWork
//
//   new iso create(main': _GetWork) =>
//     _main = main'
//     fun apply(session: HTTPSession): HTTPHandler ref^ =>
//       HttpNotify.create(_main, session)
//
// class HttpNotify is HTTPHandler
//   """
//   Handle the arrival of responses from the HTTP server.  These methods are
//   called within the context of the HTTPSession actor.
//   """
//   let _main: _GetWork
//   let _session: HTTPSession
//
//   new ref create(main': _GetWork, session: HTTPSession) =>
//     _main = main'
//     _session = session
//
//   fun ref apply(response: Payload val) =>
//     """
//     Start receiving a response.  We get the status and headers.  Body data
//     *might* be available.
//     """
//     _main.have_response(response)
//
//   fun ref chunk(data: ByteSeq val) =>
//     """
//     Receive additional arbitrary-length response body data.
//     """
//     _main.have_body(data)
//
//   fun ref finished() =>
//     """
//     This marks the end of the received body data.  We are done with the
//     session.
//     """
//     _main.finished()
//     _session.dispose()
//
//   fun ref cancelled() =>
// _main.cancelled()
