function initswarmuniform(f, Opts::PSOOptions)

    # Initialize Swarm 
    swarm = Swarm(Opts.NDims, Opts.SwarmSize)

    # Create Matrix of Initial Positions wth Uniform Distribution
    if Opts.InitialSwarmMatrix[1] === NaN
        Pos = SizedMatrix{Opts.NDims, Opts.SwarmSize}(
            Opts.InitialSwarmSpan .* (rand(Opts.NDims, Opts.SwarmSize) .- 0.5)
        )
    elseif size(Opts.InitialSwarmMatrix)[2] >= Opts.SwarmSize
        Pos = SizedMatrix{Opts.NDims, Opts.SwarmSize}(
            view(Opts.InitialSwarmMatrix,:,1:Opts.SwarmSize)
        )
    else
        Pos = SizedMatrix{Opts.NDims, Opts.SwarmSize}(
            [Opts.InitialSwarmMatrix
            Opts.InitialSwarmSpan .* (rand(Opts.NDims, Opts.SwarmSize - size(Opts.InitialSwarmMatrix)[2]) .- 0.5)
            ]
        )
    end

    # Create Matrix of Initial Velocities with Uniform Distribution
    Vel = SizedMatrix{Opts.NDims, Opts.SwarmSize}(
        2 .* Opts.InitialSwarmSpan .* (rand(Opts.NDims, Opts.SwarmSize) .- 0.5)
    )

    # Set Each Particles Position and Velocity
    @inbounds for i in 1:Opts.SwarmSize
        swarm[i].x = SVector{Opts.NDims}(view(Pos,:,i))
        swarm[i].p = SVector{Opts.NDims}(view(Pos,:,i))
        swarm[i].v = SVector{Opts.NDims}(view(Vel,:,i))
    end

    # Compute Objective Function for all Particles in Swarm
    if Opts.UseParallel
        Threads.@threads for i in 1:Opts.SwarmSize
            swarm[i].fx = f(swarm[i].x)
            swarm[i].fp = swarm[i].fx
        end
    else
        for i in 1:Opts.SwarmSize
            swarm[i].fx = f(swarm[i].x)
            swarm[i].fp = swarm[i].fx
        end
    end

    # Check Objective Function Values if Desired
    if Opts.FunValCheck == "on"
        fvalcheck(swarm)
    end

    # Set Global Best
    setgbest!(swarm)

    # Initialize Neighborhood Size
    swarm.N = max(2, floor(Opts.SwarmSize*Opts.MinNeighborsFraction))

    # Initialize Inertia
    if Opts.InertiaRange[2] > 0
        if Opts.InertiaRange[2] > Opts.InertiaRange[1]
            swarm.W = copy(Opts.InertiaRange[2])
        else
            swarm.W = copy(Opts.InertiaRange[1])
        end
    else
        if Opts.InertiaRange[2] < Opts.InertiaRange[1]
            swarm.W = copy(Opts.InertiaRange[2])
        else
            swarm.W = copy(Opts.InertiaRange[1])
        end
    end

    # Initialize Self and Social Adjustment Weights
    y1 = Opts.SelfAdjustmentWeight
    y2 = Opts.SocialAdjustmentWeight

    # Print Status
    if Opts.Display == "iter"
        printstatus(swarm, 0.0, 0, 0)
    end

    return swarm
end
