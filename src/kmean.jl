module kmean
using Distributions
using Random
using Printf

function k_mean(X::AbstractMatrix{<:Real},
     k::Integer,
     w::Array{<:Real};
     maxiter::Integer=200, # maximun iteration
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
     inertia = 0
     while delta > tol
         if iter_num > maxiter
             break
         end

         for i in range(1, length=n, step =1)
             distList = Float64[]
             for j in range(1, length=k, step=1)
                 append!(distList, distance(centers[:,j], X[:, i]))
             end
             # println(distList)
             dist, ind = findmin(distList)
             # print(ind)
             # * w[i]
             clustDist[i, :] = [dist, ind]
         end
         inertia = 0
         for j in range(1, length = k, step = 1)
              dInx = clustDist[:, 2].==j
              dist_t = clustDist[:, 1].==j
              inertia += mean(dist_t)
              # println(dInx)
              ptInCluster = X[:, dInx]
              # ptWeight = w[dInx]
              # ptWeight = ptWeight ./ sum(ptWeight)
              #* ptWeight
              centers_new[:,j] = mean(ptInCluster, dims=2)
              # println(centers_new[:,j])
         end
         # println(centers_new)
         # println(centers_new - centers)
         delta = sum((centers_new - centers).^2)
         centers = copy(centers_new)
         @printf("iter:\t%d\tdelta:\t%0.4f\n", iter_num, delta)
         # println("delta: $delta")
         iter_num += 1
     end
     # println(centers)
     cent = deepcopy(centers)
     inertia -= sum(var(cent, dims=2))/k
     # println(centers)
     return centers, inertia
end

function init_centers(X::AbstractMatrix{<:Real},
     k::Integer)
     d, n = size(X)

     # init_index = rand(1:n, k)
     # init_centers = X[:,init_index]
     init_index = Inf64[]
     index = rand(1:n)
     init_cluster = X[:,index]
     init_centers = Array{Float64, 2}(undef, d, k)
     distListTotal = Array{Float64, 1}(undef, n)
     init_centers[:,1] = init_cluster

     for i in 2:k
         sum_all = 0
         for j in 1:n
             distList = Float64[]
             for j in 1:i
                 append!(distList, distance(init_centers[:,i], X[:, j]))
             end
             dist, ind = findmin(distList)
             distListTotal[j] = dist
             sum_all += dist
         end
         sum_all *= rand()
         for j in 1:n
             di = distListTotal[k]
             sum_all -= di
             if sum_all > 0
                 continue
             end
             init_centers[:,i] = X[:, j]
             break
         end
     end
     return init_centers
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

function K_mean(X::AbstractMatrix{<:Real},
     k::Integer,
     w::Array{<:Real};
     maxiter::Integer=100, # maximun iteration
     tol::Real=1e-4, # tolearance of change at converage
     random_state::Integer=10
     )
     d, n = size(X)
     centers_ls = Array{Float64, 3}(undef, random_state, d, k)
     inertia_ls = []
    for iter in 1:random_state
        centers, inertia = k_mean(X, k, w)
        if sum(isnan.(centers)) > 0
            continue
        end
        # println(centers_ls)
        # println(typeof(centers_ls))
        println(size(centers))
        centers_ls[iter,:,:] = centers
        append!(inertia_ls, inertia)
    end
    inertia_min, min_ind = findmin(inertia_ls)
    return centers_ls[min_ind,:,:]
end

end  # module kmean
