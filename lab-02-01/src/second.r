foo <- function(n) {
  if (n > 0) {
    return(n * foo(n - 1))
  } else {
    return(1)
  }
}

# Проверка
result <- foo(7)
cat("foo(7) =", result, "\n")  # Выведет: foo(7) = 5040