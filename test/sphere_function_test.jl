using JuSwarm, StaticArrays, Test

function spherefunc(x::AbstractVector)
    return sum(x.^2)
end

N = 14
opts = PSOOptions(N; Display = "none")

sol = psoptimize(spherefunc,opts)

@test sol.fbest <= 1.0e-6