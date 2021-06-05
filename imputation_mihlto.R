library(mice)
library(lubridate)
library(VIM)

df <- read.csv("troponin_pod1_regression_input.csv")
#md.pattern(df)

p_missing <- unlist(lapply(df, function(x) sum(is.na(x))))/nrow(df)
sort(p_missing[p_missing>0], decreasing = TRUE)

imputed <- mice(df, m=30, maxit=500, meth='rf', ntree=10, seed=20210517, print=FALSE)
for (ind in seq(1, 30)) {
	df_imputed = complete(imputed, ind)
	write.csv(df_imputed, sprintf("troponin_pod1_regression_imputed_data%02d.csv", ind), row.names=FALSE)
}

png("Figures/figures2.png", width=1000, height=1000, unit='px', family="Times New Roman")
densityplot(imputed)
dev.off()
