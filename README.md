# JuSwarm.jl

[![Build Status](https://travis-ci.com/GrantHecht/JuSwarm.jl.svg?branch=master)](https://travis-ci.com/GrantHecht/JuSwarm.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/GrantHecht/JuSwarm.jl?svg=true)](https://ci.appveyor.com/project/GrantHecht/JuSwarm-jl)
[![Coverage](https://codecov.io/gh/GrantHecht/JuSwarm.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/GrantHecht/JuSwarm.jl)
[![Coverage](https://coveralls.io/repos/github/GrantHecht/JuSwarm.jl/badge.svg?branch=master)](https://coveralls.io/github/GrantHecht/JuSwarm.jl?branch=master)

# Gradient Free Nonlinear Optimization with PSO
JuSwarm.jl is a package for solving nonlinear multivariate optimization problems using the gradient-free Partical Swarm Optimization (PSO) algorithm. 

# Simple Example
Considering the multivariate Rastrigin Function of n-diamentions:
```
f(x) = 10*length(x) + sum(x.^2 - 10*cos.(2*π.*x)
```
The minimum can be found using JuSwarm.jl with a hybrid optimizer provided by Optim.jl as follows (considering the 2-diamention Rastrigin function):
```
using JuSwarm
using Optim
using StaticArrays

f(x) = 10*length(x) + sum(x.^2 - 10*cos.(2*π.*x))

Num_Of_Dims = 2
PSOoptions = PSOOptions(Num_Of_Dims; 
                        SwarmSize = 200,
                        LowerBounds = SVector{Num_Of_Dims}(fill(-5.12, Num_Of_Dims, 1)),
                        UpperBounds = SVector{Num_Of_Dims}(fill(5.12, Num_Of_Dims, 1)),
                        HybridOptimizer = Optim.LBFGS())

sol = psoptimize(f, PSOoptions)

# Found minimum
x = sol.xbest

# Objective function value corresponding to found minimum 
fx = sol.fbest
```

# Available Options
!!! Need to update this portion of the readme !!!

JuSwarm.jl is implimented similarly to MATLAB's PSO implimentation (particleswarm.m) and contains many of the same options.
For the time being, please reference MATLAB's particleswarm.m documentation to see available options and thier discriptions. 
Additionally, feel free to reference the JuSwarm.jl tests for more examples of its usage.




