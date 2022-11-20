using MeshesToolbox
using Test
using MeshViz
using Meshes
import GLMakie as Mke
using ColorSchemes

θ = LinRange(0,2π,15)[1:end-1]
φ = LinRange(π/4,π,20)

x = [sin(φ[i])*cos(θ[j]) for j in eachindex(θ) for i in eachindex(φ) ]
y = [sin(φ[i])*sin(θ[j]) for j in eachindex(θ) for i in eachindex(φ) ]
z = [cos(φ[i])   for j in eachindex(θ) for i in eachindex(φ) ]

vertex = [Point3(x[i], y[i], z[i]) for i ∈ eachindex(x)]

periodic = (true, true)

topo = GridTopology( (length(φ) -1,length(θ) ), (false, true))
mesh = SimpleMesh(vertex, topo)

fig = Mke.Figure(resolution = (400, 400))
viz(fig[1,1], mesh, showfacets = true)
fig
# viz(mesh)