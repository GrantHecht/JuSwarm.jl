module JuSwarm

# Dependancies
using StaticArrays
using Format
using StatsBase
using LinearAlgebra

# Includes
include("PSOOptions.jl")
include("Particle.jl")
include("Swarm.jl")
include("initswarmuniform.jl")
include("psoptimize.jl")

export PSOOptions
export psoptimize

end
