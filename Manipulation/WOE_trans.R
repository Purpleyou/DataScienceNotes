
require(Information)


WOE.trans = function(data, target) {
  # Input:
  #       data: a data to transform with woe values, dataframe
  #       target: the name of the dependent variable, string
  # Output: 
  #       transformed data: a transformed data with woe, dataframe
  
  # inner functions:
  
  which_group = function(x) {
    if (is.na(x)) {
      return(NA)
    }                              # `if` first, then `for` loop
    
    if (x > cuts[length(cuts)]) {
      return(length(cuts) + 1)
    }
    
    for (i in 1:length(cuts)) {
      if (x <= cuts[i]) {
        return(i)
      }
    }
  }
  
  map_woe = function(woe, cuts, value) {
    # input:
    #       woe: a list of woes of a specific variable
    #       cuts: a list of cutpionts of a specific variable
    #       value: a single value
    # output:
    #       map_woe: woe mapped to the single value
    
    # !!! Note: we didn't consider the case that no NA is the training data,
    #           but NA exits in the test data.
    
    if (is.na(value) && is.na(cuts[1])) {
      return(woe[1])
    }    # woe[1] is the woe of `NA`
    
    if (is.na(cuts[1])) {
      for (i in 2:length(cuts)) {
        if (value <= cuts[i]) {
          return (woe[i])
        }
      }
    } else{
      for (i in 1:length(cuts)) {
        if (value <= cuts[i]) {
          return (woe[i])
        }
      }
    }          # woe[2] to woe[-2]
    
    return(woe[length(woe)])                     # woe[-1]
  }
  
  map_woe_vec = function(woe, cuts, vector) {
    # input:
    #       woe: a list of woes of a specific variable
    #       cuts: a list of cutpionts of a specific variable
    #       vector: a vecotr
    # output:
    #       map_woe_vec: woes mapped to the vector
    
    n = length(vector)
    v = rep(0, n)
    
    v = sapply(1:n, function(i)
      map_woe(woe, cuts, vector[i]))
    
    return(v)
  }
  
  #
  columns = names(data[!(names(data) %in% target)])      # return the independent variable names
  
  new_vector = c()
  new_name = c()
  
  for (i in 1:length(columns)) {
    vec = data[, columns[i] == names(data)]
    if (length(unique(vec)) > 30) {                      # only transform a variable when the unique values > 30
      
      df = data.frame(value = vec, target = data[, target])
      
      if (anyNA(df$value)) {                             # omit NA to use disc.Topdown
        df.no.na = na.omit(df)
        TD = disc.Topdown(df.no.na)                      # CAIM algorithm
      } else{
        TD = disc.Topdown(df)                            # CAIM algorithm
      }                                                  # ifelse returns a list
      
      cuts = TD$cutp[[1]][-c(1, (length(TD$cutp[[1]])))] # remove the 1st and the last values
      
      df$group = as.numeric(lapply(df$value, function(x) which_group(x)))
      
      # calculate woe
      
      n_groups = ifelse(anyNA(df$value), length(cuts) + 2, length(cuts) + 1)
      woe = rep(0, n_groups)
      N_good = length(which(df$target == 1)); N_bad = length(df$target) - N_good
      Q = log(N_good / N_bad)
      
      if (anyNA(df$value)) {
        n_good = length(which(df[which(is.na(df$group)), ]$target == 1))
        n_bad = length(which(df[which(is.na(df$group)), ]$target == 0))
        woe[1] = log(n_good / n_bad) - Q                  # woe[1] for NA class
        
        for (i in 1:(n_groups - 1)) {
          n_good = length(which(df[which(df$group == i), ]$target == 1))
          n_bad = length(which(df[which(df$group == i), ]$target == 0))
          woe[i + 1] = log(n_good / n_bad) - Q
        }
      } else{                                             # for data containing no NA
        for (i in 1:n_groups) {
          n_good = length(which(df[which(df$group == i), ]$target == 1))
          n_bad = length(which(df[which(df$group == i), ]$target == 0))
          woe[i] = log(n_good / n_bad) - Q
        }
      }             
      
      cuts = ifelse(anyNA(df$value), c(NA, cuts), cuts)
      
      new_vector = cbind(new_vector, map_woe_vec(woe, cuts, df$value))
    } else{
      new_vector = cbind(new_vector, vec)
    }                                      
    
    new_name = c(new_name, columns[i])
    df_new = as.data.frame(new_vector)
    names(df_new) = new_name
  }                    # mapping
  
  output = as.data.frame(cbind(data[,target], df_new))
  names(output)[1] = target
  
  return(output)
}


# test data ================================================================

data(train, package = "Information")
data(valid, package = "Information")

train.transformed = WOE.trans(train, "PURCHASE")
