# Создаем дженерик-функцию area
area <- function(x, ...) {
  UseMethod("area")
}

# Метод по умолчанию
area.default <- function(x, ...) {
  warning("Невозможно обработать данные: неподдерживаемый тип фигуры")
  NA
}

# Метод для круга (один параметр - радиус)
area.circle <- function(x, ...) {
  if(length(x) != 1 || !is.numeric(x) || x <= 0) {
    warning("Для круга требуется один положительный числовой параметр (радиус)")
    return(NA)
  }
  pi * x^2
}

# Метод для прямоугольника (два параметра - длина и ширина)
area.rectangle <- function(x, ...) {
  if(length(x) != 2 || !is.numeric(x) || any(x <= 0)) {
    warning("Для прямоугольника требуется два положительных числовых параметра (длина и ширина)")
    return(NA)
  }
  x[1] * x[2]
}

# Метод для треугольника (три параметра - стороны, используется формула Герона)
area.triangle <- function(x, ...) {
  if(length(x) != 3 || !is.numeric(x) || any(x <= 0)) {
    warning("Для треугольника требуется три положительных числовых параметра (стороны)")
    return(NA)
  }
  
  # Проверка неравенства треугольника
  if(any(x >= sum(x[-which.max(x)]))) {
    warning("Данные стороны не образуют треугольник")
    return(NA)
  }
  
  p <- sum(x) / 2
  sqrt(p * (p - x[1]) * (p - x[2]) * (p - x[3]))
}

# Примеры использования:
circle_param <- structure(5, class = "circle")
rectangle_param <- structure(c(4, 6), class = "rectangle")
triangle_param <- structure(c(3, 4, 5), class = "triangle")
invalid_param <- structure(1:4, class = "pentagon")

area(circle_param)    # 78.53982
area(rectangle_param) # 24
area(triangle_param)  # 6
area(invalid_param)   # Предупреждение и NA

