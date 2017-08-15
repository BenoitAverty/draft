use "logger"

/**
 * Simulate a bunch of users that do their action simultaneously
 */
class val Simulation
  let _logger: Logger[String]

  let _populations: Array[Population] val

  new val create(populations: Array[Population] val, logger: Logger[String]) =>
    _logger = logger
    _populations = populations

  fun start() =>
    for pop in _populations.values() do
      pop.spawn_users()
    end
