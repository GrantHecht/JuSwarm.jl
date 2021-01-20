using JuSwarm, StaticArrays, Test

function rastriginfunc(x::AbstractVector)
    d = length(x)

    sum = 0.0
    for i in 1:d
        sum += (x[i]^2 - 10*cos(2*π*x[i]))
    end
    return 10*d + sum
end

N = 2
opts = PSOOptions(N; SwarmSize = 200,
                     LowerBounds = SVector{N}(fill(-5.12, N, 1)),
                     UpperBounds = SVector{N}(fill(5.12, N, 1)),
                     Display = "none",
                     UseParallel = true)

sol = psoptimize(rastriginfunc,opts)

@test sol.fbest <= 1.0e-6