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
psa_big <- make_psa_obj(example_psa$cost,
                        example_psa$effectiveness,
                        example_psa$parameters,
                        example_psa$strategies)

## -----------------------------------------------------------------------------
evpi_obj <- calc_evpi(psa = psa_big,
                      wtp = example_psa$wtp,
                      pop = 1)
head(evpi_obj)

## -----------------------------------------------------------------------------
p <- plot(evpi_obj,
          txtsize = 16,
          effect_units = "QALY",
          currency = "Dollars ($)",
          xbreaks = seq(0, 200, by = 10),
          ylim = c(0, 100000))
p

## -----------------------------------------------------------------------------
evppi <- calc_evppi(psa = psa_big,
                    wtp = c(5e4, 1e5, 2e5, 3e5),
                    params = c("pFailSurg", "pFailChemo"),
                    outcome = "nmb",
                    type = "gam",
                    k = 3,
                    pop = 1,
                    progress = FALSE)
head(evppi[[1]])

plot(evppi)

## -----------------------------------------------------------------------------
evsi <- calc_evsi(psa = psa_big,
                  wtp = 5e4,
                  params = c("pFailSurg", "pFailChemo"),
                  outcome = "nmb",
                  k = 3,
                  n = seq(from = 10, to = 200, by = 10),
                  n0 = 50,
                  pop = 1,
                  progress = FALSE)

head(evsi[[1]])

plot(evsi)

## -----------------------------------------------------------------------------
mm <- metamodel(analysis = "twoway",
                psa = psa_big,
                params = c("pFailChemo", "cChemo"),
                strategies = "Chemo",
                outcome = "eff",
                type = "gam")

## -----------------------------------------------------------------------------
print(mm)

## -----------------------------------------------------------------------------
summary(mm)

## -----------------------------------------------------------------------------
pred_mm <- predict(mm,
                   ranges = list("pFailChemo" = c(0.3, 0.6),
                                 "cChemo" = NULL),
                   nsamp = 10)
head(pred_mm)

