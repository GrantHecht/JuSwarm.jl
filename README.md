# JuSwarm

[![Build Status](https://travis-ci.com/GrantHecht/JuSwarm.jl.svg?branch=master)](https://travis-ci.com/GrantHecht/JuSwarm.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/GrantHecht/JuSwarm.jl?svg=true)](https://ci.appveyor.com/project/GrantHecht/JuSwarm-jl)
[![Coverage](https://codecov.io/gh/GrantHecht/JuSwarm.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/GrantHecht/JuSwarm.jl)
[![Coverage](https://coveralls.io/repos/github/GrantHecht/JuSwarm.jl/badge.svg?branch=master)](https://coveralls.io/github/GrantHecht/JuSwarm.jl?branch=master)

# Gradient Free Nonlinear Optimization with Particle Swarm
JuSwarm.jl is a package for solving nonlinear multivariate optimization problems using the gradient-free Partical Swarm Optimization (PSO) algorithm. 

# Simple Example
Considering the simple multivariate sphere function of n-diamentions:
```
f(x) = sum(x.^2)
```
The minimum can be found using JuSwarm.jl with a hybrid optimizer provided by Optim.jl as follows (considering the 10-diamention sphere function):
```
using JuSwarm
using Optim

f(x) = sum(x.^2)

Num_Of_Dims = 10
PSOoptions = PSOOptions(Num_Of_Dims; SwarmSize = 50, HybridOptimizer = Optim.LBFGS())

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
Additionally, please reference the JuSwarm.jl tests for more examples of its usage.




