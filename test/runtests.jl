using MeshesToolbox
using Test
using MeshViz
using Meshes
import GLMakie as Mke
using ColorSchemes


function ϕ(u,v)

    a,b = 3, 4
    x = 5/4*(1 - v/2π )*cos(2v)*(1 + cos(u)) + cos(2*v)
    y = 5/4*(1 - v/2π )*sin(2v)*(1 + cos(u)) + sin(2*v)
    z = 10*v/2π +5/4*(1 - v/2π )*sin(u) + 15

    # Point3(1, 2, 3)
    return x,y,z

end


function sphere_transform(X)

    
    x = X[1]
    y = X[2]
    z = X[3]
    r = sqrt(x^2 + y^2 + z^2)
    θ = atan(y,x)
    φ = acos(z/r)

    r_new = (1-z)*(z+1) * (1+0.05*cos(20*θ) * sin(φ)^4  )/4
    x_new = r_new*cos(θ)
    y_new = r_new*sin(θ)

    return x_new, y_new, z

end

#test 1
us = LinRange(0,2π,50)
vs = LinRange(-2π,2π,50)
mesh = ParametricConstructor(ϕ,us, vs, (false, true))
viz(mesh)

#test 2

X = [ϕ(u,v)[1] for u in us , v in vs]
Y = [ϕ(u,v)[2] for u in us , v in vs]
Z = [ϕ(u,v)[3] for u in us , v in vs]

mesh = SquareConstructor(X, Y, Z, (false, true))
viz(mesh)






#testing transform
sphere = Sphere((0.,0.,0.), 1.)
mesh = discretize(sphere, RegularDiscretization(100,100))
viz(mesh)
new_mesh = mesh_transform(sphere_transform, mesh)
viz(new_mesh)




#testing save mesh

sphere = Sphere((0.,0.,0.), 1.)
mesh = discretize(sphere, RegularDiscretization(10,60))
viz(mesh)
new_mesh = mesh_transform(sphere_transform, mesh)
viz(new_mesh, showfacets = true)
reduce(hcat,coordinates.(vertices(mesh)))
color_scale = [ sqrt(coordinates(p)[1]^2 +coordinates(p)[2]^2)  for p in vertices(new_mesh)]

SaveMesh("test_square", new_mesh, color_scale, :inferno)
# SaveMesh("Spindle", new_mesh, color_scale, (-1, 0.2), :inferno)


@testset "MeshesToolbox.jl" begin
    # Write your tests here.
end
