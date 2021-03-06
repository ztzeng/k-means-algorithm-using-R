###
title: "K-Means Algorithm"
author: "Anna (Zitong) Zeng"
###

library(rdist)
library(Rfast)
library(microbenchmark)
Kmean <- function(myScatterInput,myClusterNum){
  dims <- dim(myScatterInput)
  n_points <- dims[1]
  n_dimension <-dims[2]
  best <- Inf
  maxIter <- 1000
  nrep <- 100

  #assign points:
  for(i in 1:nrep){
    iter <- 0
    signal <- FALSE
    new_cluster <-sample(1:myClusterNum,n_points,replace=T)
    while(signal==FALSE){
      iter <- iter+1
      mynewInput <- cbind(myScatterInput,new_cluster)
      
      #compute centriod:
      Mean <- matrix(nrow=myClusterNum,ncol=n_dimension)
      for(i in 1:myClusterNum){
        Mean[i, ]<- colMeans(mynewInput[mynewInput$new_cluster==i, ][1:n_dimension])
      }
      
      #Euclidean distance to each datapoint:
      Distance <- rdist::cdist(Mean,myScatterInput)
      
      #Assign each point to the cluster centroid which minimizes the Euclidean distance.
      pre_cluster <- new_cluster
      new_cluster <- Rfast::colMins(Distance,value=F)
      if(identical(new_cluster,pre_cluster)|(iter==maxIter)){signal <- TRUE}
    }
    
    #compute the sum of all Euclidean distances from each point to their respective centroids.
    mindis <- Rfast::colMins(Distance,value=T)
    totaldis <- sum(mindis)
    
    #Identify the best.
    if (totaldis<best){
      best <- totaldis
      best_cluster <- new_cluster
    }
  }
  print(best)
  
  #plot
  if(n_dimension==2){
    mybest <- cbind(myScatterInput,best_cluster)
    print(mybest %>%ggplot()+
            geom_point(aes(x=mybest[,1],y=mybest[,2],
                           color=as.factor(mybest[,3])))+
            guides(color=guide_legend(title="Cluster"))+
            xlab("datapoint_x")+ylab("datapoint_y")+
            theme_minimal())
  }
}
```


##Tests

set.seed(101)
myScatterInput1 <- data_frame(myCol_01 = runif(100000, -1, 1))
myClusterNum1 <- 2
microbenchmark({Kmean(myScatterInput1,myClusterNum1)},times=1)


set.seed(102)
myScatterInput2 <- data_frame(myCol_01 = runif(100000, -1, 1))
myClusterNum2 <- 4
microbenchmark({Kmean(myScatterInput2,myClusterNum2)},times=1)


set.seed(103)
myScatterInput3 <- data_frame(myCol_01 = runif(10000, -5, 20), myCol_02 = c(rnorm(3000, 20, 5), rnorm(5000, -4, 2), rnorm(2000, 40, 2)))
myClusterNum3 <- 3
microbenchmark({Kmean(myScatterInput3,myClusterNum3)},times=1)


set.seed(104)
myScatterInput4 <- data_frame(myCol_01 = c(rnorm(3000, 20, 20), rnorm(5000, -4, 2), rnorm(2000, 40, 2)), myCol_02 = runif(10000, -5, 20))
myClusterNum4 <- 6
microbenchmark({Kmean(myScatterInput4,myClusterNum4)},times=1)


set.seed(105)
myScatterInput5 <- data_frame(myCol_01 = c(rnorm(3000, 20, 20), rnorm(5000, -4, 2), rnorm(2000, 40, 2)), 
                              myCol_02 = runif(10000, -5, 20),
                              myCol_03 = runif(10000, -100, 100),
                              myCol_04 = c(runif(4000, -5, 20), rnorm(6000)),
                              myCol_05 = runif(10000, -10, 200),
                              myCol_06 = rnorm(10000, -300, 1000),
                              myCol_07 = rnorm(10000, -1000000, 1000000),
                              myCol_08 = rnorm(10000, 30, 2))
myClusterNum5 <- 3
microbenchmark({Kmean(myScatterInput5,myClusterNum5)},times=1)


set.seed(106)
myScatterInput6 <- data_frame(myCol_01 = c(rnorm(3000, 20, 20), rnorm(5000, -4, 2), rnorm(2000, 40, 2)), 
                              myCol_02 = runif(10000, -5, 20),
                              myCol_03 = runif(10000, -100, 100),
                              myCol_04 = c(runif(4000, -5, 20), rnorm(6000)),
                              myCol_05 = runif(10000, -10, 200),
                              myCol_06 = rnorm(10000, -300, 1000),
                              myCol_07 = rnorm(10000, -1000000, 1000000),
                              myCol_08 = rnorm(10000, 30, 2))
myClusterNum6 <- 12
microbenchmark({Kmean(myScatterInput6,myClusterNum6)},times=1)


