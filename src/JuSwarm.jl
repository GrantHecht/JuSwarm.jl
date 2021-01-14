module JuSwarm

# Dependancies
using StaticArrays
using Format
using StatsBase
using LinearAlgebra
using Plots

# Includes
include("PSOOptions.jl")
include("Particle.jl")
include("Swarm.jl")
include("initswarmuniform.jl")
include("psoptimize.jl")
include("PSOSolution.jl")

export PSOOptions
export psoptimize

end
