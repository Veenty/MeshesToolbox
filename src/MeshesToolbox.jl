module MeshesToolbox

using Meshes
using ColorSchemes
using PlyIO
using ScatteredInterpolation

function ParametricConstructor(ϕ,us, vs, periodic)

    # create the nodes

    vertex = [Point3(ϕ(u,v)...) for u in us for v in vs]

    topo = GridTopology( (length(vs)-1 , length(us)-1) .+ periodic, periodic)
    mesh = SimpleMesh(vertex, topo)

    return mesh


end

export ParametricConstructor


function SquareConstructor(X, Y, Z, periodic)

    Nu, Nv = size(X)
    println(Nu, Nv)

    vertex= [Point3(X[i,j], Y[i,j], Z[i,j]) for i in 1:Nu for j in 1:Nv]
    println("largo de esta lista ", length(vertex))

    #note that the entries go the other way 
    topo = GridTopology( (Nv-1, Nu-1 ) .+ periodic, periodic)

    return SimpleMesh(vertex, topo)

end


export SquareConstructor




function mesh_transform(ϕ, mesh)


    return SimpleMesh([Point3(ϕ(p)...) for p in coordinates.(vertices(mesh))], topology(mesh) )
    


end

export mesh_transform


function SaveMesh(filename, mesh, color_scale, colormap)


    colomax = maximum(color_scale)
    colomin = minimum(color_scale)

    # normalize color scale
    color_norm= (color_scale .- colomin) ./ (colomax .- colomin)

    nverts = length(vertices(mesh))
    green = Array{UInt8}(undef, nverts)
    blue = Array{UInt8}(undef, nverts)
    red = Array{UInt8}(undef, nverts)

    for i in 1:nverts
        color = get(colorschemes[colormap], color_norm[i])
        red[i] = UInt8(floor(color.r*255))
        green[i] = UInt8(floor(color.g*255))
        blue[i] = UInt8(floor(color.b*255))
    end
    #extract vertix from mesh


    vert = reduce(hcat,coordinates.(vertices(mesh)))

    ply = Ply()

    push!(ply, PlyComment("Colored Geometry"))

    nverts = length(vert)

    vertex = PlyElement("vertex",
                    ArrayProperty("x", vert[1,:] ),
                    ArrayProperty("y", vert[2,:] ),
                    ArrayProperty("z", vert[3,:] ),
                    ArrayProperty("red", red),
                    ArrayProperty("green", green),
                    ArrayProperty("blue", blue) )


    push!(ply, vertex)

    vertex_index = ListProperty("vertex_index", UInt8, Int32)
    ind =  indices.(elements(topology(mesh))) 

    for  i ∈ ind 

        push!(vertex_index, i .-1)
   
        
    end

    push!(ply, PlyElement("face", vertex_index))

    if endswith(filename, ".ply")
        save_ply(ply,filename, ascii=false)
    else
        save_ply(ply,filename*".ply", ascii=false)
    end
  

end

function SaveMesh(filename, mesh, color_scale, colorrange,colormap)


    colomax = colorrange[2]
    colomin = colorrange[1]

    # normalize color scale
    color_norm= (color_scale .- colomin) ./ (colomax - colomin) 

    nverts = length(vertices(mesh))
    green = Array{UInt8}(undef, nverts)
    blue = Array{UInt8}(undef, nverts)
    red = Array{UInt8}(undef, nverts)

    for i in 1:nverts
        color = get(colorschemes[colormap], color_norm[i])
        red[i] = UInt8(  floor(color.r*255) )
        green[i] = UInt8(floor(color.g*255))
        blue[i] = UInt8(floor(color.b*255))
    end
    #extract vertix from mesh


    vert = reduce(hcat,coordinates.(vertices(mesh)))

    ply = Ply()

    push!(ply, PlyComment("Colored Geometry"))

    nverts = length(vert)

    vertex = PlyElement("vertex",
                    ArrayProperty("x", vert[1,:] ),
                    ArrayProperty("y", vert[2,:] ),
                    ArrayProperty("z", vert[3,:] ),
                    ArrayProperty("red", red),
                    ArrayProperty("green", green),
                    ArrayProperty("blue", blue) )


    push!(ply, vertex)

    vertex_index = ListProperty("vertex_index", UInt8, Int32)
    ind =  indices.(elements(topology(mesh))) 

    for  i ∈ ind 

        push!(vertex_index, i .-1)
  
        
    end

    push!(ply, PlyElement("face", vertex_index))

    if endswith(filename, ".ply")
        save_ply(ply,filename, ascii=false)
    else
        save_ply(ply,filename*".ply", ascii=false)
    end
  


    

end
export SaveMesh


# function SmoothMesh(Xs,Ys,Zs, Ws, mesh, ϵ)

#     # Xs, Ys, Zs are the source points
#     # Ws is the weight of the source points
#     # mesh has the target points

#     # get the coordinates of the target points
#     target = coordinates.(vertices(mesh))


#     # create the interpolator
#     itp = interpolate(Gaussian(ϵ), [Xs; Ys; Zs],  Ws)
#     interpolated = evaluate(itp, target )

#     return interpolated

# end


end






