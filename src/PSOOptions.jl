
mutable struct PSOOptions{L,M}

    # PSO Options similar to MATLABs PSO implemtation options

    # CreationFcn # Impliment later to allow for different (potentially user defined) swarm initialization functions
    # OutputFcn   # Impliment later to allow user defined output function
    # PlotFcn     # Impliment later to allow user defined plotting function

    NDims::Int
    Display::String
    DisplayInterval::Int
    FunctionTolerance::Real
    FunValCheck::String
    InertiaRange::SVector{2}
    InitialSwarmMatrix::SMatrix{M,L}
    InitialSwarmSpan::SVector{M}
    MaxIterations::Int
    MaxStallIterations::Int
    MaxStallTime::AbstractFloat
    MaxTime::AbstractFloat
    MinNeighborsFraction::AbstractFloat
    ObjectiveLimit::AbstractFloat
    SelfAdjustmentWeight::AbstractFloat
    SocialAdjustmentWeight::AbstractFloat
    SwarmSize::Int
    UseParallel::Bool

end

function PSOOptions(NDims; Display = "iter", DisplayInterval = 1, FunctionTolerance = 1.0e-6, FunValCheck = "off", 
    InertiaRange = SVector{2}([0.1, 1.1]), InitialSwarmMatrix = nothing, InitialSwarmSpan = nothing, 
    MaxIterations = -1, MaxStallIterations = 20, MaxStallTime = Inf64, MaxTime = Inf64, MinNeighborsFraction = 0.25, 
    ObjectiveLimit = -Inf64, SelfAdjustmentWeight = 1.49, SocialAdjustmentWeight = 1.49, SwarmSize = -1, UseParallel = false)

if MaxIterations == -1
MaxIterations = 200*NDims
end
if SwarmSize == -1
SwarmSize = min(100, 10*NDims)
end
if InitialSwarmMatrix === nothing
    InitialSwarmMatrix = SMatrix{NDims, 2}(NaN .* ones(NDims, 2))
end
if InitialSwarmSpan === nothing
    InitialSwarmSpan = SVector{NDims}(2000 .* ones(NDims))
end
if UseParallel == true && Threads.nthreads() < 2
    throw(ArgumentError("More than one thread must be active to use parallel computing."))
end
if InertiaRange[1] > InertiaRange[2]
    throw(ArgumentError("InertiaRange[2] must be greater than InertiaRange[1]!"))
end

M = NDims
L = size(InitialSwarmMatrix)[2]
PSOOptions{L,M}(NDims, Display, DisplayInterval, FunctionTolerance, FunValCheck, InertiaRange, InitialSwarmMatrix,
InitialSwarmSpan, MaxIterations, MaxStallIterations, MaxStallTime, MaxTime, MinNeighborsFraction, ObjectiveLimit, 
SelfAdjustmentWeight, SocialAdjustmentWeight, SwarmSize, UseParallel)
end
