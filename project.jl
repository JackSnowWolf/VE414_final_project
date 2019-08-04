using Printf
include(joinpath("src", "data_loader.jl"))
include(joinpath("src", "model.jl"))

function main()
    df = data_loader.read_csv("data_proj_414.csv")

    train_df, test_df = data_loader.data_split(df)

    fruit_number, centers, esigma = model.fit(train_df)
    loc_arr = [train_df.X train_df.Y]'
    train_pred_fruit = model.predict(loc_arr, fruit_number, centers, esigma)
    train_mse = model.mse(train_pred_fruit, train_df.Close)
    train_acc_soft = model.accuarcy_soft(train_pred_fruit, train_df.Close)*100
    @printf("train mse:\t%2.4f\n", train_mse)
    @printf("train soft accuarcy:\t%2.2f%%\n", train_acc_soft)
    println()
    loc_arr = [test_df.X test_df.Y]'
    test_pred_fruit = model.predict(loc_arr, fruit_number, centers, esigma)
    test_mse = model.mse(test_pred_fruit, test_df.Close)
    test_acc_soft = model.accuarcy_soft(test_pred_fruit, test_df.Close)*100
    @printf("test mse:\t%2.4f\n", test_mse)
    @printf("test soft accuarcy:\t%2.2f%%\n", test_acc_soft)


    # println(summary(df))
    # println(summary(train_df))
    # println(summary(test_df))
    return train_pred_fruit
end

main()
