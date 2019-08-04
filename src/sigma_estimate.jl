module sigma_estimate

function sigma_est(point_array::AbstractMatrix{<:Real},
    center::AbstractMatrix{<:Real},
    fruit_array::AbstractMatrix{<:Real})
    n = size(point_array)[1]
    #println(n)
    #println(point_array[1,2])
    sum_x = 0
    sum_y = 0
    for i in 1:n
        sum_x = sum_x + (point_array[i, 1]-center[1])^2*fruit_array[i]
        sum_y = sum_y + (point_array[i, 2]-center[2])^2*fruit_array[i]
    end
    esigma_x = (sum_x+1)/2
    esigma_y = (sum_y+1)/2
    return esigma_x, esigma_y
end

#test code
#point_array = [4 3; 6 5; 3 3]
#center = [5 4]
#fruit_array = [2 1 3]
#sigma_x, sigma_y = sigma_estimate(point_array, center, fruit_array)
#println(sigma_x, sigma_y)

end
