## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 5,
  fig.align = "center"
)

## -----------------------------------------------------------------------------
library(dampack)
data("example_psa")

## -----------------------------------------------------------------------------
str(example_psa)

## -----------------------------------------------------------------------------
example_psa$strategies

## -----------------------------------------------------------------------------
head(example_psa$cost)

## -----------------------------------------------------------------------------
head(example_psa$effectiveness)

## -----------------------------------------------------------------------------
psa_obj <- make_psa_obj(cost = example_psa$cost,
                        effectiveness = example_psa$effectiveness,
                        parameters = example_psa$parameters,
                        strategies = example_psa$strategies,
                        currency = "$")
str(psa_obj)

## ---- fig.width = 7, fig.height = 5, fig.align = "center"---------------------
plot(psa_obj)

## -----------------------------------------------------------------------------
psa_sum <- summary(psa_obj, 
                   calc_sds = TRUE)
psa_sum

## ---- fig.width = 7, fig.height = 5, fig.align = "center"---------------------
icers <- calculate_icers(cost = psa_sum$meanCost, 
                         effect = psa_sum$meanEffect, 
                         strategies = psa_sum$Strategy)
plot(icers)

## -----------------------------------------------------------------------------
ceac_obj <- ceac(wtp = example_psa$wtp, 
                 psa = psa_obj)
head(ceac_obj)

## -----------------------------------------------------------------------------
summary(ceac_obj)

## ---- fig.width = 7, fig.height = 5, fig.align = "center"---------------------
plot(ceac_obj, 
     frontier = TRUE, 
     points = TRUE)

## ---- fig.width = 7, fig.height = 5, fig.align = "center"---------------------
el <- calc_exp_loss(wtp = example_psa$wtp, 
                    psa = psa_obj)
head(el)
plot(el, 
     n_x_ticks = 8, 
     n_y_ticks = 6)

## -----------------------------------------------------------------------------
o <- owsa(psa_obj)

## ---- fig.width = 7, fig.height = 5, fig.align = "center"---------------------
plot(o,
     n_x_ticks = 2)

## ---- fig.width = 7, fig.height = 5, fig.align = "center"---------------------
owsa_tornado(o)

## ---- fig.width = 7, fig.height = 5, fig.align = "center"---------------------
owsa_tornado(o, 
             min_rel_diff = 0.05)

## -----------------------------------------------------------------------------
owsa_tornado(o, 
             return = "data")

## ---- fig.width = 7, fig.height = 5, fig.align = "center"---------------------
owsa_opt_strat(o, 
               n_x_ticks = 5)

## -----------------------------------------------------------------------------
owsa_opt_strat(o, 
               return = "data")

## -----------------------------------------------------------------------------
tw <- twsa(psa_obj, 
           param1 = "pFailChemo", 
           param2 = "muDieCancer")

## ---- fig.width = 7, fig.height = 5, fig.align = "center"---------------------
plot(tw)

