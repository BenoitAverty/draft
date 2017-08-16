use "net/http"
use "../httpclient"
use l="logger"

primitive SimulationFactory

  /**
   * Create a hard-coded simulation for testing purposes
   */
  fun static_simulation(http_client: Http, logger: l.Logger[String]): Simulation =>
    let behaviour1: Behaviour iso = recover iso
      try
        let b = Behaviour(1)
        b.push(Request("GET", URL.build("/")?))
        b.push(WaitingPeriod(1000))
        b.push(Request("GET", URL.build("/")?))
        b
      else
        logger(l.Error) and logger.log("Could not build behaviour.")
        return Simulation(recover val Array[Population] end, logger)
      end
    end
    // let behaviour2: Behaviour iso = recover iso
    //   let b = Behaviour(1)
    //   b.push(WaitingPeriod(0))
    //   b
    // end

    let pop1: Population = ConstantRatePopulation(consume behaviour1, 1000, 100, http_client, logger)
    // let pop2: Population = ConstantRatePopulation(consume behaviour2, 10, 1, http_client, logger)

    let pops: Array[Population] val = recover val [pop1] end
    Simulation(pops, logger)
