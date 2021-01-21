using JuSwarm, StaticArrays, Test
import Optim

function rosenbrockfunc(x::AbstractVector)
    sum = 0.0
    for i in 1:length(x) - 1
        sum += 100*(x[i + 1] - x[i]^2)^2 + (x[i] - 1)^2
    end
    return sum
end

N = 2
opts = PSOOptions(N; SwarmSize = 1000, 
                     HybridOptimizer = Optim.LBFGS(),
                     Display = "none",
                     UseParallel = true)

sol = psoptimize(rosenbrockfunc,opts)

@test sol.fbest <= sol.fbestPSO

@test sol.fbestPSO <= 1.0e-6

@test sol.fbest <= 1.0e-10