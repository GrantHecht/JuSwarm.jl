struct PSOSolution{M,T}

    Swarm::Swarm # Final Swarm
    fbest::T
    xbest::SVector{M,T}

    Iters::Int
    Time::T
    ExitFlag::Int

end