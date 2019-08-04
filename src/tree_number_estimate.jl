
module tree_number_estimate

function number_estimate(df, lambda)
    fruit_sum = sum(df.Close)
    trip = findmax(df.Trip)[1]

    one_tree_fruit_density = lambda/49
    tot_tree_fruit_density = fruit_sum/400
    tree_number = sqrt(tot_tree_fruit_density/one_tree_fruit_density*fruit_sum/trip/lambda)
    return tree_number
end

end
