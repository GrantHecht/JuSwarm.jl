mutable struct Swarm{M,T}

    Particles::Vector{Particle} # Vector of Particles

    b::T                        # Global Best Objective Function Value
    d::SVector{M,T}             # Location of Global Best Objective Function

    N::Int                      # Neighborhood Size
    W::AbstractFloat            # Inertia
    c::Int                      # Adaptive Inertia Counter

    y1::AbstractFloat           # SelfAdjustmentWeight
    y2::AbstractFloat           # SocialAdjustmentWeight
        
end

##########################
#   Swarm Constructors   #
##########################
function Swarm(NDims,NParticals)
    temp = Vector{Particle}(undef, NParticals)
    for i in 1:NParticals
        temp[i] = Particle(NDims)
    end
    Swarm(temp, Inf, temp[1].p, 2, Inf, 0, 0.0, 0.0)
end

#####################
#   Swarm Methods   #
#####################

Base.length(S::Swarm) = length(S.Particles)

function Base.getindex(S::Swarm, i::Int)
    1 <= i <= length(S.Particles) || throw(BoundsError(S, i))
    return S.Particles[i]
end 

function Base.setindex!(S::Swarm, v, i::Int)
    1 <= i <= length(S.Particles) || throw(BoundsError(S, i))
    S.Particles[i] = v
end

Base.lastindex(S::Swarm) = S[length(S)]

function fvalcheck(S::Swarm)
    n = length(S.Particles)
    @inbounds for i in 1:n
        if ifinf(S[i].fx) || isnan(S[i].fx)
            throw(ErrorException("Objective function returned Inf or NaN!"))
        end
    end
end 

function setgbest!(S::Swarm)
    n = length(S)
    updated = false
    @inbounds for i in 1:n
        if S[i].fp < S.b
            S.b = S[i].fp
            S.d = deepcopy(S[i].p)
            updated = true
        end
    end
    return updated
end

function printstatus(S::Swarm, Time::AbstractFloat, Iteration::Int, StallCount::Int)
    # Time Elapsed, Iteration Number, Function Evaluations, Stall Iterations, Global Best
    fspec1 = FormatExpr("Time Elapsed: {1:f} sec, Iteration Number: {2:d}, Function Evaluations: {3:d}")
    fspec2 = FormatExpr("Stall Iterations: {1:d}, Global Best: {2:e}")
    printfmtln(fspec1, Time, Iteration, (Iteration + 1)*length(S))
    printfmtln(fspec2, StallCount, S.b)
    println(" ")
end

function updatevelocities!(S::Swarm)
    n = length(S.Particles)
    m = length(S.d)
    @inbounds for i in 1:n
        # Chose random subset of N Particles not including i
        ws = Weights([float(j != i) for j in 1:n])
        samp = sample(1:n, ws, S.N; replace=false, ordered=false)

        # Determine fbest(S)
        fbest = Inf
        best  = 0
        @inbounds for j in samp
            if S[j].fp < fbest
                fbest = S[j].fp
                best = j
            end
        end

        # Update i's velocity
        u1 = SVector{m}(rand(m))
        u2 = SVector{m}(rand(m))
        S[i].v = @. S.W*S[i].v + S.y1*u1*(S[i].p - S[i].x) + S.y2*u2*(S[best].p - S[i].x)
    end
end

function step!(S::Swarm)
    n = length(S.Particles)
    @inbounds for i in 1:n
        S[i].x = S[i].x .+ S[i].v
    end
end  

function enforcebnds!(S::Swarm, Opts::PSOOptions)
    n = length(S)
    tempx = MVector{Opts.NDims}(zeros(Opts.NDims))
    tempv = MVector{Opts.NDims}(zeros(Opts.NDims))
    @inbounds for i in 1:n
        tempx .* 0.0
        tempv .* 0.0
        @inbounds for j in 1:Opts.NDims
            if S[i].x[j] > Opts.UpperBounds[j] 
                tempx[j] = Opts.UpperBounds[j]
                tempv[j] = 0.0
            elseif S[i].x[j] < Opts.LowerBounds[j]
                tempx[j] = Opts.LowerBounds[j]
                tempv[j] = 0.0
            else
                tempx[j] = S[i].x[j]
                tempv[j] = S[i].v[j] 
            end
        end
        S[i].x = SVector{Opts.NDims}(tempx)
        S[i].v = SVector{Opts.NDims}(tempv)
    end
end

function feval!(f, S::Swarm, Opts::PSOOptions)

    # Evaluate Objective Function for all Particles
    if Opts.UseParallel
        Threads.@threads for i in 1:Opts.SwarmSize
            S[i].fx = f(S[i].x)
        end
    else
        @inbounds for i in 1:Opts.SwarmSize
            S[i].fx = f(S[i].x)
        end
    end

    # Check Objective Function Values if Desired
    if Opts.FunValCheck == "on"
        fvalcheck(S)
    end

    # Update Each Particles Best Objective Function Value and its Location
    @inbounds for i in 1:Opts.SwarmSize
        if S[i].fx < S[i].fp
            S[i].p = deepcopy(S[i].x)
            S[i].fp = S[i].fx
        end
    end
end






