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
v_hiv_strat_names <- c("status quo", "one time", "5yr", "3yr", "annual")

## -----------------------------------------------------------------------------
v_hiv_costs <- c(26000, 27000, 28020, 28440, 29440)

## -----------------------------------------------------------------------------
v_hiv_qalys <- c(277.25, 277.57, 277.78, 277.83, 277.76) / 12

## -----------------------------------------------------------------------------
icer_hiv <- calculate_icers(cost=v_hiv_costs, 
                            effect=v_hiv_qalys, 
                            strategies=v_hiv_strat_names)
icer_hiv

## ----message=FALSE,warning=FALSE----------------------------------------------
library(kableExtra)
library(dplyr)
icer_hiv %>%
  kable() %>%
  kable_styling()

## -----------------------------------------------------------------------------
plot(icer_hiv)

## -----------------------------------------------------------------------------
plot(icer_hiv, 
     label="all")

## -----------------------------------------------------------------------------
plot(icer_hiv, 
     label="all") +
  theme_classic() +
  ggtitle("Cost-effectiveness of HIV screening strategies")

## -----------------------------------------------------------------------------
library(dampack)
data("psa_cdiff")

## -----------------------------------------------------------------------------
df_cdiff_ce <- summary(psa_cdiff)
head(df_cdiff_ce)

## -----------------------------------------------------------------------------
icer_cdiff <- calculate_icers(cost = df_cdiff_ce$meanCost,
                              effect = df_cdiff_ce$meanEffect,
                              strategies = df_cdiff_ce$Strategy)
icer_cdiff %>%
  kable() %>%
  kable_styling()

## -----------------------------------------------------------------------------
icer_cdiff %>%
  filter(Status == "ND")%>%
  kable() %>%
  kable_styling()

## -----------------------------------------------------------------------------
plot(icer_cdiff)

## -----------------------------------------------------------------------------
plot(icer_cdiff, label = "all") # can lead to a 'busy' plot
plot(icer_cdiff, plot_frontier_only = TRUE) # completely removes dominated strategies from plot
plot(icer_cdiff, currency = "USD", effect_units = "quality-adjusted life-years") # customize axis labels

