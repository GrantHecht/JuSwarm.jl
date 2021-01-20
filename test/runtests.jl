
using JuSwarm, Test, SafeTestsets
@time begin
@time @safetestset "Sphere Function" begin include("sphere_function_test.jl") end 
@time @safetestset "Rosenbrock Function" begin include("rosenbrock_function_test.jl") end
@time @safetestset "Ackley Function" begin include("ackley_function_test.jl") end
@time @safetestset "Rastrigin Function" begin include("rastrigin_function_test.jl") end
end
