module model
using Distributions
include("data_repeatrate.jl")
include("tree_number_estimate.jl")
include("kmean.jl")
include("sigma_estimate.jl")


function fit(df)
    x1 = 30
    x2 = 38
    y1 = 65
    y2 = 75

    one_tree,df_close = data_repeatrate.Onetree(df,x1,x2,y1,y2)
    #println(one_tree)

    fruit_number = data_repeatrate.Areafruit(one_tree)
    #println(fruit_number)

    df_c = df[df.Close.>0,:]

    tree_number = round(Int, tree_number_estimate.number_estimate(df_c, fruit_number))

    df_k = [df_c.X df_c.Y]

    #df_k = DataFrames(X = df_c.X, Y = df_c.Y)
    #println(size(df_k))
    centers = kmean.K_mean(df_k', tree_number)
    # println("tree centers")
    # println(centers)
    clustInd = kmean.k_mean_predict(df_k', centers)
    # println(clustInd)
    df_centers = centers[:, clustInd]
    loc = [df.X df.Y]
    esigma_x, esigma_y = sigma_estimate.sigma_est(loc, df_centers, df.Close')
    esigma = [esigma_x 0; 0 esigma_y]
    return fruit_number, centers, esigma
end

function predict(loc::AbstractMatrix{<:Real},
    fruit_number::Float64,
    centers::AbstractMatrix{<:Real},
    esigma::AbstractMatrix{<:Real})
    d, n = size(loc)
    d2, k = size(centers)
    (d == 2) || throw(ArgumentError(
    "dims of data $d should be 2"))
    (d == d2) || throw(ArgumentError(
    "dims of data $d and center $d2 should be equal"))
    pred_fruit_arr = Array{Float64, 2}(undef, n, k)

    for j in 1:k
        center_t = centers[:, j]
        distriNormal = MvNormal(center_t, esigma)
        for i in 1:n
            loc_t = loc[:, i]
            pred_fruit_arr[i, j] = fruit_number * pdf(distriNormal, loc_t) * pi
        end
    end
    pred_fruit = sum(pred_fruit_arr, dims=2)[:,1]
    return pred_fruit

end # function

function mse(pred_fruit, gt_fruit)
    len1 = length(pred_fruit)
    len2 = length(gt_fruit)
    (len1 == len2) || throw(ArgumentError(
    "length of pred_fruit $len1 and gt_fruit $len2 should be equal"))
    return mean((pred_fruit - gt_fruit).^ 2)
end # function

function accuarcy_soft(pred_fruit, gt_fruit)
    len1 = length(pred_fruit)
    len2 = length(gt_fruit)
    (len1 == len2) || throw(ArgumentError(
    "length of pred_fruit $len1 and gt_fruit $len2 should be equal"))
    correct_soft = sum(abs.(pred_fruit - gt_fruit) .< 3)
    return correct_soft/len1
end

end  # module model
