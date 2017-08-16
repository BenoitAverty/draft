use "net/http"
use "../httpclient"
use l="logger"

primitive SimulationFactory

  /**
   * Create a hard-coded simulation for testing purposes
   */
  fun static_simulation(base_url: URL, http_client: Http, logger: l.Logger[String]): Simulation =>
    let behaviour1: Behaviour iso = recover iso
      let b = Behaviour(1)
      b.push(WaitingPeriod(0))
      b
    end
    let behaviour2: Behaviour iso = recover iso
      let b = Behaviour(1)
      b.push(WaitingPeriod(0))
      b
    end

    let pop1: Population = ConstantRatePopulation(consume behaviour1, 2, 10, http_client, logger)
    let pop2: Population = ConstantRatePopulation(consume behaviour2, 10, 1, http_client, logger)

    let pops: Array[Population] val = recover val [pop1;pop2] end
    Simulation(pops, logger)
