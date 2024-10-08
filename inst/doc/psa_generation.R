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
run_sick_sicker_model <- function(l_params, verbose = FALSE) {
  with(as.list(l_params), {
    # l_params must include:
    # -- disease progression parameters (annual): r_HD, p_S1S2, hr_S1D, hr_S2D,
    # -- initial cohort distribution: v_s_init
    # -- vector of annual state utilities: v_state_utility = c(u_H, u_S1, u_S2, u_D)
    # -- vector of annual state costs: v_state_cost = c(c_H, c_S1, c_S2, c_D)
    # -- time horizon (in annual cycles): n_cyles
    # -- annual discount rate: r_disc

    ####### SET INTERNAL PARAMETERS #########################################

    # state names
    v_names_states <- c("H", "S1", "S2", "D")
    n_states <- length(v_names_states)

    # vector of discount weights
    v_dw  <- 1 / ((1 + r_disc) ^ (0:n_cycles))

    # state rewards
    v_state_cost <- c("H" = c_H, "S1" = c_S1, "S2" = c_S2, "D" = c_D)
    v_state_utility <- c("H" = u_H, "S1" = u_S1, "S2" = u_S2, "D" = u_D)

    # transition probability values
    r_S1D <- hr_S1D * r_HD 	 # rate of death in sick state
    r_S2D <- hr_S2D * r_HD   # rate of death in sicker state
    p_S1D <- 1 - exp(-r_S1D) # probability of dying when sick
    p_S2D <- 1 - exp(-r_S2D) # probability of dying when sicker
    p_HD  <- 1 - exp(-r_HD)   # probability of dying when healthy

    ## Initialize transition probability matrix
    # all transitions to a non-death state are assumed to be conditional on survival
    m_P <- matrix(0,
                  nrow = n_states, ncol = n_states,
                  dimnames = list(v_names_states, v_names_states)) # define row and column names
    ## Fill in matrix
    # From H
    m_P["H", "H"]   <- (1 - p_HD) * (1 - p_HS1)
    m_P["H", "S1"]  <- (1 - p_HD) * p_HS1
    m_P["H", "D"]   <- p_HD
    # From S1
    m_P["S1", "H"]  <- (1 - p_S1D) * p_S1H
    m_P["S1", "S1"] <- (1 - p_S1D) * (1 - (p_S1H + p_S1S2))
    m_P["S1", "S2"] <- (1 - p_S1D) * p_S1S2
    m_P["S1", "D"]  <- p_S1D
    # From S2
    m_P["S2", "S2"] <- 1 - p_S2D
    m_P["S2", "D"]  <- p_S2D
    # From D
    m_P["D", "D"]   <- 1

    # check that all transition matrix entries are between 0 and 1
    if (!all(m_P <= 1 & m_P >= 0)) {
      stop("This is not a valid transition matrix (entries are not between 0 and 1")
    } else
      # check transition matrix rows add up to 1
      if (!all.equal(as.numeric(rowSums(m_P)), rep(1, n_states))) {
        stop("This is not a valid transition matrix (rows do not sum to 1)")
      }

    ####### INITIALIZATION #########################################
    # create the cohort trace
    m_Trace <- matrix(NA, nrow = n_cycles + 1,
                      ncol = n_states,
                      dimnames = list(0:n_cycles, v_names_states)) # create Markov trace

    # create vectors of costs and QALYs
    v_C <- v_Q <- numeric(length = n_cycles + 1)

    ############# PROCESS ###########################################

    m_Trace[1, ] <- v_s_init # initialize Markov trace
    v_C[1] <- 0 # no upfront costs
    v_Q[1] <- 0 # no upfront QALYs

    for (t in 1:n_cycles) { # throughout the number of cycles
      m_Trace[t + 1, ] <- m_Trace[t, ] %*% m_P # calculate trace for cycle (t + 1) based on cycle t

      v_C[t + 1] <- m_Trace[t + 1, ] %*% v_state_cost

      v_Q[t + 1] <- m_Trace[t + 1, ] %*% v_state_utility

    }

    #############  PRIMARY ECONOMIC OUTPUTS  #########################

    # Total discounted costs
    n_tot_cost <- t(v_C) %*% v_dw

    # Total discounted QALYs
    n_tot_qaly <- t(v_Q) %*% v_dw

    #############  OTHER OUTPUTS   ###################################

    # Total discounted life-years (sometimes used instead of QALYs)
    n_tot_ly <- t(m_Trace %*% c(1, 1, 1, 0)) %*% v_dw

    ####### RETURN OUTPUT  ###########################################
    out <- list(m_Trace = m_Trace,
                m_P = m_P,
                l_params,
                n_tot_cost = n_tot_cost,
                n_tot_qaly = n_tot_qaly,
                n_tot_ly = n_tot_ly)

    return(out)
  }
  )
}

## -----------------------------------------------------------------------------
simulate_strategies <- function(l_params, wtp = 100000) {
  # l_params must include:
  # -- *** Model parameters ***
  # -- disease progression parameters (annual): r_HD, p_S1S2, hr_S1D, hr_S2D,
  # -- initial cohort distribution: v_s_init
  # -- vector of annual state utilities: v_state_utility = c(u_H, u_S1, u_S2, u_D)
  # -- vector of annual state costs: v_state_cost = c(c_H, c_S1, c_S2, c_D)
  # -- time horizon (in annual cycles): n_cyles
  # -- annual discount rate: r_disc
  # -- *** Strategy specific parameters ***
  # -- treartment costs (applied to Sick and Sicker states): c_trtA, c_trtB
  # -- utility with Treatment_A (for Sick state only): u_trtA
  # -- hazard ratio of progression with Treatment_B: hr_S1S1_trtB

  with(as.list(l_params), {

    ####### SET INTERNAL PARAMETERS #########################################
    # Strategy names
    v_names_strat <- c("No_Treatment", "Treatment_A", "Treatment_B")
    # Number of strategies
    n_strat <- length(v_names_strat)

    ## Treatment_A
    # utility impacts
    u_S1_trtA <- u_trtA
    # include treatment costs
    c_S1_trtA <- c_S1 + c_trtA
    c_S2_trtA <- c_S2 + c_trtA

    ## Treatment_B
    # progression impacts
    r_S1S2_trtB <- -log(1 - p_S1S2) * hr_S1S2_trtB
    p_S1S2_trtB <- 1 - exp(-r_S1S2_trtB)
    # include treatment costs
    c_S1_trtB <- c_S1 + c_trtB
    c_S2_trtB <- c_S2 + c_trtB

    ####### INITIALIZATION #########################################
    # Create cost-effectiveness results data frame
    df_ce <- data.frame(Strategy = v_names_strat,
                        Cost = numeric(n_strat),
                        QALY = numeric(n_strat),
                        LY = numeric(n_strat),
                        stringsAsFactors = FALSE)

    ######### PROCESS ##############################################
    for (i in 1:n_strat) {
      l_params_markov <- list(n_cycles = n_cycles, r_disc = r_disc, v_s_init = v_s_init,
                              c_H =  c_H, c_S1 = c_S2, c_S2 = c_S1, c_D = c_D,
                              u_H =  u_H, u_S1 = u_S2, u_S2 = u_S1, u_D = u_D,
                              r_HD = r_HD, hr_S1D = hr_S1D, hr_S2D = hr_S2D,
                              p_HS1 = p_HS1, p_S1H = p_S1H, p_S1S2 = p_S1S2)

      if (v_names_strat[i] == "Treatment_A") {
        l_params_markov$u_S1 <- u_S1_trtA
        l_params_markov$c_S1 <- c_S1_trtA
        l_params_markov$c_S2 <- c_S2_trtA

      } else if (v_names_strat[i] == "Treatment_B") {
        l_params_markov$p_S1S2 <- p_S1S2_trtB
        l_params_markov$c_S1   <- c_S1_trtB
        l_params_markov$c_S2   <- c_S2_trtB
      }

      l_result <- run_sick_sicker_model(l_params_markov)

      df_ce[i, c("Cost", "QALY", "LY")] <- c(l_result$n_tot_cost,
                                             l_result$n_tot_qaly,
                                             l_result$n_tot_ly)
      df_ce[i, "NMB"] <- l_result$n_tot_qaly * wtp - l_result$n_tot_cost
    }

    return(df_ce)
  })
}

## -----------------------------------------------------------------------------
my_params <- c(#Transition probabilities
               "p_HS1",
               "p_S1H",
               "p_S1S2",
               #Hazard ratios
               "hr_S1",
               "hr_S2",
               "hr_S1S2_trtB",
               #Costs
               "c_H",
               "c_S1",
               "c_S2",
               "c_trtA",
               "c_trtB",
               #Utilities
               "u_H",
               "u_S1",
               "u_S2",
               "u_TrtA")

my_dists <- c(#Transition probabilities
              "beta",
              "beta",
              "beta",
              #Hazard ratios
              "log-normal",
              "log-normal",
              "log-normal",
              #Costs
              "gamma",
              "gamma",
              "gamma",
              "gamma",
              "gamma",
              #Utilities
              "truncated-normal",
              "truncated-normal",
              "truncated-normal",
              "truncated-normal")

my_parameterization_types <- c(#Transition Probabilities
                               "a, b",
                               "a, b",
                               "a, b",
                               #Hazard ratios
                               "mean, sd",
                               "mean, sd",
                               "mean, sd",
                               #Costs
                               "shape, scale",
                               "shape, scale",
                               "shape, scale",
                               "shape, scale",
                               "shape, scale",
                               #Utilities
                               "mean, sd, ll, ul",
                               "mean, sd, ll, ul",
                               "mean, sd, ll, ul",
                               "mean, sd, ll, ul")

my_dists_params <- list(#Transition Probabilities
                        c(7.5, 42.5),
                        c(12, 12),
                        c(15, 133),
                        #Hazard ratios
                        c(3, 0.5),
                        c(10, 0.5),
                        c(0.6, .01),
                        #Costs
                        c(44.5, 45),
                        c(178, 22.5),
                        c(900, 16.67),
                        c(576, 21),
                        c(676, 19),
                        #Utilities
                        c(1, 0.01, NA, 1),
                        c(0.75, 0.02, NA, 1),
                        c(0.5, 0.03, NA, 1),
                        c(0.95, 0.02, NA, 1))

my_psa_params <- gen_psa_samp(params = my_params,
                              dists = my_dists,
                              parameterization_types = my_parameterization_types,
                              dists_params = my_dists_params,
                              n = 100)

## -----------------------------------------------------------------------------
my_params_basecase <- list(p_HS1 = 0.15,
                           p_S1H = 0.5,
                           p_S1S2 = 0.105,
                           r_HD = 0.002,
                           hr_S1D = 3,
                           hr_S2D = 10,
                           hr_S1S2_trtB = 0.6,
                           c_H = 2000,
                           c_S1 = 4000,
                           c_S2 = 15000,
                           c_D = 0,
                           c_trtA = 12000,
                           c_trtB = 13000,
                           u_H = 1,
                           u_S1 = 0.75,
                           u_S2 = 0.5,
                           u_D = 0,
                           u_trtA = 0.95,
                           n_cycles = 75,
                           v_s_init = c(1, 0, 0, 0),
                           r_disc = 0.03)

psa_output <- run_psa(psa_samp = my_psa_params,
                      params_basecase = my_params_basecase,
                      FUN = simulate_strategies,
                      outcomes = c("Cost", "QALY", "LY", "NMB"),
                      strategies = c("No_Treatment", "Treatment_A", "Treatment_B"),
                      progress = FALSE)

## -----------------------------------------------------------------------------
cea_psa <- make_psa_obj(cost = psa_output$Cost$other_outcome,
                        effect = psa_output$QALY$other_outcome,
                        parameters = psa_output$Cost$parameters,
                        strategies = psa_output$Cost$strategies,
                        currency = "$")

