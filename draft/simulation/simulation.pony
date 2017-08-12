use "logger"

/**
 * Simulate a bunch of users that do their action simultaneously
 */
class Simulation
  let _logger = Logger[String]

  let _users = List[User]

  new create(logger: Logger[String]) =>
    _logger = logger

  fun run() =>
    for(user: User in _users.values()) do
      user.play_scenario()
    end
