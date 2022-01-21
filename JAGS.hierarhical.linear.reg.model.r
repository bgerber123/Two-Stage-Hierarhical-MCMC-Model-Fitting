#hierarhical linear regression model

model{
  
  ##### Priors
  tau.beta~dgamma(0.001,0.001)
  var.beta <- 1 / tau.beta
  
  mu.beta~dnorm(0, 0.001)
  
  tau.groups~ dgamma(0.001,0.001)
  var.groups <- 1 / tau.groups
 
  #### data model
  for(k in 1:nobs){
    y[k] ~ dnorm(mu[k],tau.beta)
    
    mu[k] <- beta[x.cov[k]] 
  }
  
  #### hierarchical model for beta ######
  for(i in 1:J) {
    beta[i] ~ dnorm(mu.beta,tau.groups)
  }
  
}