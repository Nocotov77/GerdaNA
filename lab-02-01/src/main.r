sum <- 0
for (i in 1:7) {
  lessons <- as.numeric(readline(paste("Введите количество занятий в день", i, ": ")))
  sum <- sum + lessons
}
avg <- sum / 7
rounded_avg <- round(avg)
cat("Среднее количество занятий в неделю:", rounded_avg, "\n")