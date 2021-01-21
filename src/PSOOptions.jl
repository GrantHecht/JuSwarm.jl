
struct PSOOptions{L,M}

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
    LowerBounds::SVector{M}
    UpperBounds::SVector{M}
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
    HybridFcn::Bool
    HybridOptimizer::Union{Nothing, Optim.AbstractOptimizer}
    HybridOptimizerOpts::Union{Nothing, Optim.Options}

end

function PSOOptions(NDims; Display = "iter", DisplayInterval = 1, FunctionTolerance = 1.0e-6, FunValCheck = "off", 
                    InertiaRange = SVector{2}([0.1, 1.1]), InitialSwarmMatrix = nothing, InitialSwarmSpan = nothing, 
                    LowerBounds = nothing, UpperBounds = nothing, MaxIterations = -1, MaxStallIterations = 20, 
                    MaxStallTime = Inf64, MaxTime = Inf, MinNeighborsFraction = 0.25, ObjectiveLimit = -Inf, 
                    SelfAdjustmentWeight = 1.49, SocialAdjustmentWeight = 1.49, SwarmSize = -1, UseParallel = false,
                    HybridFcn = false, HybridOptimizer = nothing, HybridOptimizerOpts = nothing)

    if MaxIterations == -1
        MaxIterations = 200*NDims
    end
    if SwarmSize == -1
        SwarmSize = min(100, 10*NDims)
    end
    if InitialSwarmMatrix === nothing
        InitialSwarmMatrix = SMatrix{NDims, 2}(fill(NaN, (NDims, 2)))
    end
    if InitialSwarmSpan === nothing
        InitialSwarmSpan = SVector{NDims}(fill(2000, (NDims, 1)))
    end
    if LowerBounds === nothing
        LowerBounds = SVector{NDims}(fill(-Inf, (NDims, 1)))
    end
    if UpperBounds === nothing
        UpperBounds = SVector{NDims}(fill(Inf, (NDims, 1)))
    end
    if UseParallel == true && Threads.nthreads() < 2
        throw(ArgumentError("More than one thread must be active to use parallel computing."))
    end
    if HybridFcn && HybridOptimizer === nothing
        HybridOptimizer = NelderMead()
    end
    if HybridOptimizer !== nothing
        HybridFcn = true
    end
    if HybridFcn && HybridOptimizerOpts === nothing
        HybridOptimizerOpts = Optim.Options()
    end
    if InertiaRange[1] > InertiaRange[2]
        throw(ArgumentError("InertiaRange[2] must be greater than InertiaRange[1]!"))
    end

    M = NDims
    L = size(InitialSwarmMatrix)[2]
    PSOOptions{L,M}(NDims, Display, DisplayInterval, FunctionTolerance, FunValCheck, InertiaRange, InitialSwarmMatrix,
                    InitialSwarmSpan, LowerBounds, UpperBounds, MaxIterations, MaxStallIterations, MaxStallTime, MaxTime, 
                    MinNeighborsFraction, ObjectiveLimit, SelfAdjustmentWeight, SocialAdjustmentWeight, SwarmSize, UseParallel,
                    HybridFcn, HybridOptimizer, HybridOptimizerOpts)
end
