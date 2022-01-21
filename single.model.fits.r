#Fit each jth group data (from simulate.data.r) independently
#To be done in parallel

#Setup environment
rm(list=ls())
library(rjags)
library(foreach)
library(doParallel)

#Load data
load("data.jags")


#setup parallel backend to use many processors
cores=detectCores()
cl <- makeCluster(cores[1]-1) #not to overload your computer
registerDoParallel(cl)

#Parallel dopar loop using a non-hierarhical linear regression model
out.parallel<-foreach(i=1:data.jags$J,.inorder = TRUE,
                      .combine=list,.multicombine = TRUE,
                      .maxcombine=data.jags$J,
                      .packages = c("rjags","runjags"))%dopar% {

y=data.jags$y[data.jags$x.cov==i]
nobs=length(y)

                        
data=list(
  nobs=nobs,
  y=y
)

parms=c("beta","var.beta")	
n.chains=1
n.adapt=2000
n.iter=10000
thin=1
burn=4000


jm=jags.model(file="JAGS.linear.reg.model.r", 
              data=data, n.chains=n.chains, n.adapt=n.adapt)

update(jm, n.iter=burn)
coda.samples(jm, variable.names=parms, n.iter=n.iter, thin=thin)

}
#stop cluster
stopCluster(cl)

#make sure we have J outputs
length(out.parallel)

#save MCMC ouputs in a list
file.out.name=paste("out.parallel.single.fit")
save(out.parallel, file=file.out.name)

################################
################################
#Plot results
mcmc.list=lapply(out.parallel,FUN=function(x){data.frame(x[[1]])})
length(mcmc.list)

#look at individual beta estimates by changing iter
iter=4
hist(mcmc.list[[iter]]$beta)
abline(v=data.jags$beta[iter],lwd=3)

#look at all distributions
hist(mcmc.list[[1]]$beta,xlim=c(-1,4))
for(i in 2:length(mcmc.list)){
  hist(mcmc.list[[i]]$beta,add=TRUE)  
  abline(v=data.jags$beta[i],lwd=3,col=2)
}
