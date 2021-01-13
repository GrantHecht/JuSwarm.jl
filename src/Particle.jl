
mutable struct Particle{M,T}

    x::SVector{M,T} # Current Position
    v::SVector{M,T} # Current Velocity
    p::SVector{M,T} # Best Position

    fx::T # Current Objective Function Value
    fp::T # Best Objective Function Value

end

function Particle(x::SVector{M,T}, v::SVector{M,T}) where {M,T}
    Particle(x, v, NaN.*x, Inf*x[1], Inf*x[1])
end

function Particle(x::SVector{M,T}) where {M,T}
    Particle(x, NaN.*x, NaN.*x, Inf*x[1], Inf*x[1])
end

function Particle(M)
    x = SVector{M}(NaN.*zeros(M))
    Particle(x, NaN.*x, NaN.*x, Inf*x[1], Inf*x[1])
end


