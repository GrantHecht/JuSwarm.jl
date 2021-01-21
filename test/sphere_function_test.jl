using JuSwarm, Optim, StaticArrays, Test

function spherefunc(x::AbstractVector)
    return sum(x.^2)
end

N = 14
PSOopts = PSOOptions(N; HybridOptimizer = Optim.LBFGS(), Display = "none")

sol = psoptimize(spherefunc, PSOopts)

@test sol.fbest <= sol.fbestPSO

@test sol.fbestPSO <= 1.0e-6

@test sol.fbest <= 1.0e-10