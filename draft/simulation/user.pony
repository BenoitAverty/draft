use "logger"

/**
 * Sequentially executes a series of requests
 */
actor User
  let _logger: Logger[String]

  let _requests: List[RequestDescriptor]

  new create(logger: Logger[String]) =>
    _logger = logger

  be apply() =>
    _logger(Fine) and _logger.log("User beginning to act.")
