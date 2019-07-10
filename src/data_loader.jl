module data_loader
using CSV, DataFrames, Random

function read_csv(file_name)
    df = CSV.read("data_proj_414.csv";
    delim=",",
    types=Dict("Potter"=>Bool,
    "Weasley"=>Bool,
    "Granger"=>Bool))
    df = DataFrame(df)
    return df
end

function data_split(df, proportion=0.9)
    n = nrow(df)
    idx = shuffle(1:n)
    train_idx = view(idx, 1:floor(Int, proportion*n))
    test_idx = view(idx, (floor(Int, proportion*n)+1):n)
    train_df = df[train_idx, :]
    test_df = df[test_idx, :]
    return train_df, test_df
end
end  # module
