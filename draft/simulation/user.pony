use "promises"
use "logger"
use "time"

use "../httpclient"

/**
 * Sequentially executes a series of requests.
 * The series of requests are given as an Iterator (the "behaviour") that can contain requests or waiting periods.
 */
actor User
  let _logger: Logger[String]
  let _client: Http
  let _behaviour: Iterator[(Request|WaitingPeriod)] ref

  new create(behaviour: Iterator[(Request|WaitingPeriod)] iso, client: Http, logger: Logger[String]) =>
    _logger = logger
    _behaviour = consume behaviour
    _client = client

  be do_behaviour() =>
    for action in _behaviour do
      match action
      | let r: Request =>
        _logger(Fine) and _logger.log("firing request " + r.method() + " to " + r.path().string() + ".")
        match r.method()
        | "GET" => _client.get(r.path(), Promise[HttpResponse])
        end
      | let w: WaitingPeriod =>
        _logger(Fine) and _logger.log("Waiting for " + w.duration().string() + " milliseconds.")

        // For a waiting period, the behaviour calls itself after a
        let t = Timer(_RecursiveUserBehaviour(this), w.duration() * 1_000_000)
        Timers.create().apply(consume t)
        return
      end
    end

/**
 * This is the TimerNotify used by the user class when it wants to call its own do_behaviour() after a timer.
 */
class _RecursiveUserBehaviour is TimerNotify
  let _user: User
  new iso create(user: User) => _user = user
  fun apply(t: Timer, c: U64): Bool =>
    _user.do_behaviour()
    true
