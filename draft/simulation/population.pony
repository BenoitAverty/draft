use "logger"
use "time"
use "collections"

use "../httpclient"

trait tag Population
  be spawn_users()

actor ConstantRatePopulation is Population
  let _logger: Logger[String]

  /* Http client that the users will use to perform their requests */
  let _client: Http
  /* The behaviour that each user will have */
  let _behaviour: Behaviour val
  /* How many users are in this population */
  let _headcount: USize
  /* Over which duration will the user perform their behaviour */
  let _duration: U64 //seconds

  new create(behaviour: Behaviour iso, headcount: USize, duration: U64, client: Http, logger: Logger[String]) =>
    _behaviour = consume behaviour
    _headcount = headcount
    _duration = duration
    _client = client
    _logger = logger

  be spawn_users() =>
    _logger(Fine) and _logger.log("Population starting to spawn users.")

    let users_iterator: Iterator[User] iso = recover iso
      let users = Array[User](_headcount)
      for i in Range(0, _headcount) do
        let b = recover iso _behaviour.values() end
        users.push(User(consume b, _client, _logger))
      end
      users.values()
    end

    let timer = Timer(_UserStartCallback(consume users_iterator), 0, (_duration*1_000_000_000) / _headcount.u64())
    Timers.create().apply(consume timer)

class _UserStartCallback is TimerNotify
  let _users_iterator: Iterator[User] ref
  new iso create(users_iterator: Iterator[User] iso) =>
    _users_iterator = consume users_iterator

  fun ref apply(t: Timer, c: U64): Bool =>
    try
      _users_iterator.next()?.do_behaviour()
    else
      return false
    end

    if not _users_iterator.has_next() then
      return false
    end
    
    true
