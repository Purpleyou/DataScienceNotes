# OptimizedR
Notes about how to optimize R codes. 

## Table of Contents
1. [Forget `for` Loops]

## Forget `for` Loops

**Nested `for` Loops**
DD
```
for(i in seq(0.1, 1, 0.1)){
  for(j in seq(1, 10, 1)){
  function(i, j)                                      # any function with parameter i and j
  }
}D
sapply(seq(0.01, .1, 0.01), function(i)       
  sapply(seq(1, 3, 1), function(j)
    function(i, j)))
```
