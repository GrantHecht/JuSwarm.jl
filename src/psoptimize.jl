
function psoptimize(f, Opts::PSOOptions)

    # Initialize Parameters
    Time0 = time()
    Iterations = 0

    StallTime0 = Time0
    StallIterations = 0
    FStall = Inf

    # Initialize Swarm with Uniform Distribution
    swarm = initswarmuniform(f, Opts)

    # Compute Minimum Neighborhood Size
    MinNeighborhoodSize = max(2, floor(Opts.SwarmSize * Opts.MinNeighborsFraction))

    # Begin loop
    stop = false
    while !stop

        # Update Iteration Counter
        Iterations += 1
        
        # Update Swarm Velocities
        updatevelocities!(swarm)

        # Update Positions
        step!(swarm)

        # Enforce Bounds
        if !all(isinf.(Opts.LowerBounds)) && !all(isinf.(Opts.UpperBounds))
            enforcebnds!(swarm, Opts)
        end

        # Evaluate Objective Function
        feval!(f, swarm, Opts)

        # Update Global Best
        flag = setgbest!(swarm)

        # Update Stall Counter and Neighborhood
        if flag
            swarm.c = max(0, swarm.c - 1)
            swarm.N = MinNeighborhoodSize
        else
            swarm.c += 1
            swarm.N = min(swarm.N + MinNeighborhoodSize, Opts.SwarmSize - 1)
        end

        # Update Inertia
        if swarm.c < 2
            swarm.W *= 2.0
        elseif swarm.c > 5
            swarm.W /= 2.0
        end

        # Ensure Inertia is in InertiaRange
        if swarm.W > Opts.InertiaRange[2]
            swarm.W = Opts.InertiaRange[2]
        elseif swarm.W < Opts.InertiaRange[1]
            swarm.W = Opts.InertiaRange[1]
        end

        # Track Stalling
        if FStall - swarm.b > Opts.FunctionTolerance
            FStall = swarm.b
            StallIterations = 0
            StallTime0 = time()
        else
            StallIterations += 1
        end

        # Stopping Criteria
        if StallIterations >= Opts.MaxStallIterations
            stop = true
        elseif Iterations >= Opts.MaxIterations
            stop = true
        elseif swarm.b <= Opts.ObjectiveLimit
            stop = true
        elseif time() - StallTime0 >= Opts.MaxStallTime
            stop = true
        elseif time() - Time0 >= Opts.MaxTime
            stop = true
        end

        # Output Status
        if Opts.Display == "iter" && Iterations % Opts.DisplayInterval == 0
            printstatus(swarm, time() - Time0, Iterations, StallIterations)
        end
    end

    return PSOSolution(swarm, swarm.b, swarm.d, Iterations, time() - Time0, 1)
end