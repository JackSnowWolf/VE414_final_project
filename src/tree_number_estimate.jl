module tree_number_estimate

function number_estimate(df, lambda)
    fruit_sum = sum(df.Close)
    trip = findmax(df.Trip)[1]
    dfm = df[df.Close.>0, :]
    A = 49*3.16
    AT = area_estimate(dfm)
    println(AT)
    println("lalalal")
    fruit_per_area = lambda/A
    fruit_per_point = fruit_sum/size(dfm)[1]
    tree_number = round(Int, AT/A*fruit_per_point/fruit_per_area)
    return tree_number
end


function area_estimate(df)
    n = size(df)[1]
    len, wid = 108, 108
    arr = rand(len, wid)
    for i in 1:len
        for j in 1:wid
            arr[i, j] = 0
        end
    end
    for i in 1:n
        if df.Close[i]>0
            x = round(Int, df.X[i])
            y = round(Int, df.Y[i])
            arr[x, y] = 1
        end
    end
    area = sum(arr)
    return area/2
end

#test script
#df = CSV.read("H:\\julia_pro\\project\\data_proj_414.csv")
#dfm = df[df.Trip.<10, :]
#println(area_estimate(dfm))
#lambda = 65
#tree_number = number_estimate(df, lambda)
#println(tree_number)

end
