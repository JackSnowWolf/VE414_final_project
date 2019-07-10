include("src/data_loader.jl")

df = data_loader.read_csv("data_proj_414.csv")

train_df, test_df = data_loader.data_split(df)
println(summary(df))
println(summary(train_df))
println(summary(test_df))
