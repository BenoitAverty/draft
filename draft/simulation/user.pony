use "logger"
use "../httpclient"

/**
 * Sequentially executes a series of requests
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
    _logger(Fine) and _logger.log("User beginning to act.")
