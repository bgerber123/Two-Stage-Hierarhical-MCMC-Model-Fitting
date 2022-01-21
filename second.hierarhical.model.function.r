second.hierarhical.model.function=function(mcmc.list,n.mcmc){

J=length(mcmc.list)

#Tuning parameters
mu.beta.tune=0.2
beta.sd.tune=0.05
#beta.tune=0.2

#Initial parameters
mu.beta=mean(unlist(lapply(mcmc.list,FUN=function(x){mean(x$beta)})))
beta=unlist(lapply(mcmc.list,FUN=function(x){mean(x$beta)}))
beta.sd=0.5
#n.mcmc=10000


mu.beta.save=rep(0,n.mcmc)
beta.save=matrix(0,n.mcmc,J)
beta.sd.save=rep(0,n.mcmc)
beta.acc=mh.s2=mu.beta.acc=0

#Start MCMC loop
for(k in 1:n.mcmc){
   if(k%%100==0) cat(k," "); flush.console()

  #For each k, we need to randomly sample from each beta posterior
  #These are the proposals
  post.first.stage.samples=unlist(lapply(mcmc.list,FUN=function(x){sample(x$beta,1)}))

  
  ###
  ### Sample mu.beta
  ###

  #proposal
  mu.betastar=rnorm(1,mu.beta,mu.beta.tune)
  mh1=sum(dnorm(beta,mu.betastar,beta.sd,log=TRUE))
  mh2=sum(dnorm(beta,mu.beta,beta.sd,log=TRUE))

  mhratio=exp(mh1-mh2)
  if(mhratio > runif(1)){
    mu.beta=mu.betastar   
    mu.beta.acc=mu.beta.acc+1
  }

  ###
  ### Sample beta.sd
  ###
  beta.sd.star=exp(rnorm(1,log(beta.sd),beta.sd.tune))  
  
  mh1=sum(dnorm(beta,mu.beta,beta.sd.star,log=TRUE))
  mh2=sum(dnorm(beta,mu.beta,beta.sd,log=TRUE))
  mh=exp(mh1-mh2)
  
  if(mh > runif(1)){
    beta.sd=beta.sd.star
    mh.s2=mh.s2+1
  }
  
  ###
  ### Sample beta_j (each group)
  ###

  #proposal
  #betastar=rnorm(J,beta,beta.tune)
  mh1=sum(dnorm(post.first.stage.samples,mu.beta,beta.sd,log=TRUE))
  mh2=sum(dnorm(beta,mu.beta,beta.sd,log=TRUE))

  mhratio=exp(mh1-mh2)
  if(mhratio > runif(1)){
    beta=post.first.stage.samples   
    beta.acc=beta.acc+1
  }
  
  
 ###
  ### Save Samples 
  ###

  mu.beta.save[k]=mu.beta
  beta.save[k,]=beta
  beta.sd.save[k]=beta.sd
}

#function output
list(mu.beta.save=mu.beta.save,beta.save=beta.save,
     beta.sd.save=beta.sd.save,beta.acc=beta.acc,
     mh.s2=mh.s2,mu.beta.acc=mu.beta.acc)
  
  
}