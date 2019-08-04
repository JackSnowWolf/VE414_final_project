module kmean
using Distributions
function K_mean(X::AbstractMatrix{<:Real},
     k::Integer;
     maxiter::Integer=500, # maximun iteration
     tol::Real=1e-6 # tolearance of change at converage
     )
     d, n = size(X)
     (2 <= k < n) || throw(ArgumentError("k must be 2 <= k < n, k=$k given."))
     centers =  init_centers(X, k)
     # println(centers)
     centers_new = Array{Float64, 2}(undef, d, k)
     # println(centers)
     clustDist = zeros(n, 2)
     delta = 1.0
     iter_num = 1
     while delta > tol
         if iter_num > maxiter
             break
         end

         centers_new = copy(centers)
         for i in range(1, length=n, step =1)
             distList = Float64[]
             for j in range(1, length=k, step=1)
                 append!(distList, distance(centers[:,j], X[:, i]))
             end
             # println(distList)
             dist, ind = findmin(distList)
             # print(ind)
             clustDist[i, :] = [dist, ind]
         end

         for j in range(1, length = k, step = 1)
              dInx = clustDist[:, 2].==j
              # println(dInx)
              ptInCluster = X[:, dInx]
              centers_new[:,j] = mean(ptInCluster, dims=2)
              # println(centers_new[:,j])
         end
         # println(centers_new)
         # println(centers_new - centers)
         delta = sum((centers_new - centers).^2)
         # println("delta: $delta")
         iter_num += 1
     end
     # println(centers)
     return centers
end

function init_centers(X::AbstractMatrix{<:Real},
     k::Integer)
     d, n = size(X)
     init_index = collect(range(1, stop=n, length=k))
     init_index = floor.(Int, init_index)
     init_center = X[:, init_index]
     return init_center
end

function distance(v1, v2)
    sqrt(sum((v1 - v2).^2))
end

function k_mean_predict(X::AbstractMatrix{<:Real},
    centers::AbstractMatrix{<:Real})
    d, n = size(X)
    d2, k = size(centers)
    (d == d2) || throw(ArgumentError(
    "dims of data $d and center $d2 should be equal"))
    clustInd = Int[]
    for i in range(1, length=n, step =1)
        distList = Float64[]
        for j in range(1, length=k, step=1)
            append!(distList, distance(centers[:,j], X[:, i]))
        end
        # println(distList)
        dist, ind = findmin(distList)
        # print(ind)
        append!(clustInd, ind)
    end
    return clustInd
end

end  # module kmean
