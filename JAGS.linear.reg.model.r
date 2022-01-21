#hierarhical linear regression model

model{
  
  
  ##### Priors
  tau.beta~dgamma(0.001,0.001)
  var.beta <- 1 / tau.beta
  
  beta~dnorm(0, 0.001)
  

  #### linear regression model
  for(k in 1:nobs){
    y[k] ~ dnorm(beta,tau.beta)
    
  }
  
}