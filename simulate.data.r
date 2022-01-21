#Author: Brian D. Gerber

#Created 1/21/2022

#Purpose: To evaluate using a two-stage model fitting process on a simple model, as done
#in McCaslin, HM, AB Feuka, and MB Hooten. (2020) "Hierarchical computing for hierarchical models in ecology." Methods in Ecology and Evolution.

#Clear Working Space and setup environment
  rm(list=ls())
  library(ggplot2)

#How many samples per group?
  n=100

#How many groups, such that there will be J beta estimates
  J=10

#Population Mean and sd of all beta's
  mu.beta=2
  sigma.beta=1

#Sample beta j
  set.seed(45345)
  beta=rnorm(J,mu.beta,sigma.beta)
  sigma.y=0.2
#Simulate Data
y=NULL
for(i in 1:J){y=c(y,rnorm(n,beta[i],sigma.y))}

#look at data
length(y)
hist(y)

#Create identifier for each group
x.cov=rep(1:J,each=n)

nobs=length(y)

data.plot=data.frame(y,x.cov)
colnames(data.plot)

ggplot(data.plot,aes(x=y,group=x.cov))+
  geom_histogram(position="dodge",binwidth=0.25)+theme_bw()

#output data
data.jags=list(nobs=nobs,x.cov=x.cov,J=J,y=y,
               beta=beta,mu.beta=mu.beta,sigma.y=sigma.y,sigma.beta=sigma.beta)

save(data.jags,file="data.jags")
