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

    let pop1: Population = ConstantRatePopulation(consume behaviour1, 1, 1, logger)

    let pops: Array[Population] val = recover val [pop1] end
    Simulation(pops, logger)
