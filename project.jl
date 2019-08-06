using Printf
using DataFrames
include(joinpath("src", "data_loader.jl"))
include(joinpath("src", "model.jl"))

df = data_loader.read_csv("data_proj_414.csv")

train_df, test_df = data_loader.data_split(df)
#fruit_number, centers, esigma = model.fit(df)
fruit_number, centers, esigma = model.fit(train_df)
@printf("fruit number:\t%d\n", floor(fruit_number))
@printf("Sample tree number:\t%d\n", size(centers)[2])
@printf("Total tree number:\t%d\n", size(centers)[2]*3)
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
train_df[:predict_close] =  train_pred_fruit
train_df[:diff_close] = map((x, y) -> abs((y-x)),
train_df[:, :predict_close], train_df[:, :Close])
data_loader.save_csv(train_df, "predict.csv")
center_df = DataFrame(X = centers[1, :], Y = centers[2, :])
data_loader.save_csv(center_df, "centers.csv")

# println(summary(df))
# println(summary(train_df))
# println(summary(test_df)


# main()
