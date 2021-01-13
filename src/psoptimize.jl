function psoptimize(f, Opts::PSOOptions)

    # Initialize Parameters
    Time0 = time()
    Iterations = 0

    StallTime0 = copy(Time0)
    StallIterations = 0
    FStall = Inf

    # Initialize Swarm with Uniform Distribution
    swarm = initswarmuniform(f, Opts)

    # Compute Minimum Neighborhood Size
    MinNeighborhoodSize = max(2, floor(Opts.SwarmSize * Opts.MinNeighborsFraction))

    # Begin loop
    stop = false
    while !stop

        # TEMP: Plot Particles
        #plotparticles(swarm)

        # Update Iteration Counter
        Iterations += 1
        
        # Update Swarm Velocities
        updatevelocities!(swarm)

        # Update Positions
        step!(swarm)

        # Enforce Bounds (not implemented)

        # Evaluate Objective Function
        feval!(f, swarm, Opts)

        # Update Global Best
        flag = setgbest!(swarm)

        # Update Stall Counter and Neighborhood
        if flag
            swarm.c = max(0, swarm.c - 1)
            swarm.N = copy(MinNeighborhoodSize)

            # Update Inertia
            if swarm.c < 2
                swarm.W *= 2.0
            elseif swarm.c > 5
                swarm.W /= 2.0
            end

            # Ensure Inertia is in InertiaRange
            if swarm.W > Opts.InertiaRange[2]
                swarm.W = copy(Opts.InertiaRange[2])
            elseif swarm.W < Opts.InertiaRange[1]
                swarm.W = copy(Opts.InertiaRange[1])
            end
        else
            swarm.c += 1
            swarm.N = min(swarm.N + MinNeighborhoodSize, Opts.SwarmSize - 1)
        end

        # Track Stalling
        if FStall - swarm.b > Opts.FunctionTolerance
            FStall = copy(swarm.b)
            StallIterations = 0
            StallTime0 = time()
        else
            StallIterations += 1
        end

        # Stopping Criteria
        if StallIterations > Opts.MaxStallIterations
            stop = true
        elseif Iterations > Opts.MaxStallIterations
            stop = true
        elseif swarm.b < Opts.ObjectiveLimit
            stop = true
        elseif time() - StallTime0 > Opts.MaxStallTime
            stop = true
        elseif time() - Time0 > Opts.MaxTime
            stop = true
        end

        # Output Status
        if Opts.Display == "iter" && Iterations % Opts.DisplayInterval == 0
            printstatus(swarm, time() - Time0, Iterations, StallIterations)
        end
    end

    return swarm
end