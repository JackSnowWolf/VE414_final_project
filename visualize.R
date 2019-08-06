library(ggplot2)
predict.df = read.csv("predict.csv", header =  TRUE, sep="\t")
predict_close.df = predict.df[predict.df$Close>0, ]
centers.df = read.csv("centers.csv", header = TRUE, sep = "\t")
scatter_p <- ggplot(centers.df, aes(x = X, y = Y)) + 
  geom_point(aes(x = X, y=Y), data = predict_close.df,size=log(predict_close.df$Close+1), color="#00AFBB", alpha = 0.5) +
  geom_point(size = 10, color = "red", alpha=1, shape = 1)
  
scatter_p
# ggsave("fruit_with_trees.jpg")  

err.df <- data.frame(mse = c(4.5257, 4.9831), soft_acc = c(0.8869, 0.8820), type = c("train", "test"))
mse_p <- ggplot(data = err.df, aes(x = type, y = mse, fill = type)) + 
  geom_bar(stat="identity", width = 0.5)+
  geom_text(aes(label=type), vjust=1.6, color="white",position = position_dodge(0.9), size=3.5)+
  theme_minimal()
ggsave("mse.jpg")

acc_p <- ggplot(data = err.df, aes(x = type, y = soft_acc, fill = type)) + 
  geom_bar(stat="identity", width = 0.5)+
  geom_text(aes(label=type), vjust=1.6, color="white",position = position_dodge(0.9), size=3.5)+
  theme_minimal()
ggsave("soft_acc.jpg")
