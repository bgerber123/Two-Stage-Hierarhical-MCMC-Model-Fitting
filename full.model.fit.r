#Fit the full hierarchical model; this will be used to compare
#when doing independent fits to each group j, and using the 2nd stage 
#MCMC algorithim

#Clean and setup environment
rm(list=ls())
library(rjags)

#load data prepared by "simulate.data.r"
load("data.jags")

#prepare data for JAGS
data=list(
  nobs=data.jags$nobs,
  y=data.jags$y,
  J=data.jags$J,
  x.cov=data.jags$x.cov
)

#Setup parameters and model fitting inputs
parms=c("mu.beta","beta","var.beta","var.groups")	
n.chains=1
n.adapt=2000
n.iter=10000
thin=1
burn=4000

###############################
#Fit model in JAGS
jm=jags.model(file="JAGS.hierarhical.linear.reg.model.r", 
              data=data, n.chains=n.chains, n.adapt=n.adapt)

update(jm, n.iter=burn)
out=coda.samples(jm, variable.names=parms, n.iter=n.iter, thin=thin)

file.out.name=paste("out.full.model",sep="")
save(out, file=file.out.name)
###############################
###############################
#Plot results
head(out[[1]])

#Setup mcmc output for plottin
mcmc=data.frame(out[[1]])

#Plot posterior of mu.beta and the true value
hist(mcmc$mu.beta,xlim=c(0,4))
abline(v=data.jags$mu.beta,col=4,lwd=2)

#add in beta's and compare to true jth value
for(i in 1:data.jags$J){hist(mcmc[,i],add=TRUE,col=2)
  abline(v=data.jags$beta[i],col=2)}

#Look at variance parameters
hist(sqrt(mcmc$var.beta))
abline(v=data.jags$sigma.y,col=2)

hist(sqrt(mcmc$var.groups))
abline(v=data.jags$sigma.beta,col=2)

