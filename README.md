
# Example code to try a two-stage model fitting process for a linear hierarchical model.  

---

See description of two-stage hierarhical model fitting here: McCaslin, HM, AB Feuka, and MB Hooten. (2020) "Hierarchical computing for hierarchical models in ecology." Methods in Ecology and Evolution.



### Script/Model Filess

**simulate.data.r** - Script to simulates a hierarchical linear model

**single.model.fits.r** - Script that fits a set if independent linear model (1st stage). Output is used in the 2nd stage script.

**second.hierarhical.model.fit.r** - Script to implenent the 2nd stage hierarhical model

**second.hierarhical.model.function.r** - Function that implements an MCMC algorithm with Metropolis-Hastings steps for a second stage hierarhical model.

### Scripts

**JAGS.linear.reg.model.r.R** - JAGS code for a simple linear regression model

**JAGS.hierarhical.linear.reg.model.r**- JAGS code for a hierarhical linear regression model

---
