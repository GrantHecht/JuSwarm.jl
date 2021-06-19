using JuSwarm, StaticArrays, Test
import Optim

function ackleyfunc(x::AbstractVector)
    a = 20
    b = 0.2
    c = 2*π
    d = length(x)

    sum1 = 0.0
    sum2 = 0.0
    for i in 1:d
        sum1 += x[i]^2
        sum2 += cos(c*x[i])
    end
    return -a*exp(-b*sqrt(sum1/d))  - exp(sum2/d) + a + exp(1)
end

N = 20
opts = PSOOptions(N; SwarmSize = 200,
                     LowerBounds = SVector{N}(fill(-32.768, N, 1)),
                     UpperBounds = SVector{N}(fill(32.768, N, 1)),
                     HybridOptimizer = Optim.LBFGS(),
                     Display = "none",
                     UseParallel = true)

sol = psoptimize(ackleyfunc,opts)

@test sol.fbest <= sol.fbestPSO

@test sol.fbestPSO <= 1.0e-6

@test sol.fbest <= 1.0e-10