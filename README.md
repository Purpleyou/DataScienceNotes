# OptimizedR
Notes about how to optimize R codes. 

## Table of Contents
1. [Forget `for` Loops](#Forget `for` Loops)

## Forget `for` Loops

**Nested `for` Loops**

As `for` loops in `R` are extremly slow, it is better to wrap the process into a nested `sapply` function. 

*Note:* To update a global vairable inside a function, use `<<-`.

```
# nested for loop
for(i in seq(0.1, 1, 0.1)){
  for(j in seq(1, 10, 1)){
  function(i, j)                                      # any function with parameter i and j
  }
}

# improved version, nested sapply loop
sapply(seq(0.1, 1, 0.1), function(i)       
  sapply(seq(1, 10, 1), function(j)
    function(i, j)))
```
