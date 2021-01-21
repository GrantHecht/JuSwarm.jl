struct PSOSolution{M,T}

    Swarm::Swarm # Final Swarm
    fbest::T
    xbest::SVector{M,T}

    Iters::Int
    Time::T
    ExitFlag::Int

    # If a hybrid function is also used. (May decide to remove this in the future)
    HybridFcnRes::Union{Nothing, Optim.OptimizationResults}
    fbestPSO::Union{Nothing, T}
    xbestPSO::Union{Nothing, SVector{M,T}}

end

function PSOSolution(S::Swarm, fbest::T, xbest::SVector{M,T}, 
                     Iters::Int, Time::T, ExitFlag::Int) where {M,T}
    PSOSolution(S, fbest, xbest, Iters, Time, ExitFlag, nothing, nothing, nothing)
end