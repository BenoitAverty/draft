use "logger"

trait tag Population
  be spawn_users()

actor ConstantRatePopulation is Population
  let _logger: Logger[String]

  /* The behaviour that each user will have */
  let _behaviour: Behaviour ref
  /* How many users are in this population */
  let _headcount: U64
  /* Over which duration will the user perform their behaviour */
  let _duration: U64

  new create(behaviour: Behaviour iso, headcount: U64, duration: U64, logger: Logger[String]) =>
    _behaviour = consume behaviour
    _headcount = headcount
    _duration = duration
    _logger = logger

  be spawn_users() =>
    _logger(Fine) and _logger.log("Population starting to span users.")
