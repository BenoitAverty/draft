use l="logger"
use "net/http"

use "simulation"
use "httpclient"

actor Main
  new create(env: Env) =>
    let logger = l.StringLogger(l.Fine, env.out)

    let base_url = try
      URL.build("http://localhost:8888")?
    else
      logger(l.Error) and logger.log("Could not build URL for string http://perdu.com")
      return
    end

    let http_client = try
      Http(base_url, env.root as AmbientAuth, logger)
    else
      logger(l.Error) and logger.log("Couldn't create the HTTP client")
      return
    end


    let simulation = SimulationFactory.static_simulation(http_client, logger)

    simulation.start()
