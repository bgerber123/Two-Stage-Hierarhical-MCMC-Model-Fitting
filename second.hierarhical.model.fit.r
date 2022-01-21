#Use a 2nd stage MCMC function to estimate population mean
#of beta_j, beta.sd, and shrunk beta_j.

#linear model on beta
# so mu.beta~dnorm(beta[j],group.sd)

#Setup environment
rm(list=ls())

#load the full model results
load("out.full.model")
out=data.frame(out[[1]])

#load in the posterior distributions that are the the single/first-stage model fitting
load("out.parallel.single.fit")
mcmc.list=lapply(out.parallel,FUN=function(x){data.frame(x[[1]])})
length(mcmc.list)
head(mcmc.list[[1]])


#Source 2nd stage function and fit model. 
#inputs are in the function file
source("second.hierarhical.model.function.r")
n.mcmc=10000
out.second=  second.hierarhical.model.function(mcmc.list,n.mcmc=n.mcmc)

#evaluate MH acceptance
out.second$mu.beta.acc/n.mcmc
out.second$mu.beta.acc/n.mcmc
out.second$mh.s2/n.mcmc

#Look at traceplots
plot(out.second$mu.beta.save,type="l")
plot(out.second$beta.save[,5],type="l")
plot(out.second$beta.save[,10],type="l")

#Plot posterior for mu.beta - 2nd stage
hist(out.second$mu.beta.save,freq = FALSE,breaks=20,
     xlab="mu.beta",main="")
#Add in posterior samples from full hierarchial model
hist(out$mu.beta,add=TRUE,freq=FALSE,col=2,breaks=60)


#Compare each beta
j.beta=8
hist(out.second$beta.save[,j.beta],freq = FALSE,breaks=20,
     xlab="beta",main="",xlim=c(min(out.second$beta.save[,j.beta])*0.9,min(out.second$beta.save[,j.beta])*1.1))
#posterior samples from full model
hist(out[,j.beta],add=TRUE,freq=FALSE,col=2,breaks=20)

#compare beta_j from full model to first stage model
j=8
hist(out[,2])
hist(mcmc.list[[2]][,1],add=TRUE,col=2)


  