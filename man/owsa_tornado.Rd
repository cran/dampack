% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/owsa.R
\name{owsa_tornado}
\alias{owsa_tornado}
\title{Tornado plot of a one-way sensitivity analysis}
\usage{
owsa_tornado(
  owsa,
  return = c("plot", "data"),
  txtsize = 12,
  min_rel_diff = 0,
  col = c("full", "bw"),
  n_y_ticks = 8,
  ylim = NULL,
  ybreaks = NULL
)
}
\arguments{
\item{owsa}{an owsa object}

\item{return}{either return a ggplot object \code{plot} or a data frame with
ranges of parameters for which each strategy is optimal.}

\item{txtsize}{base text size}

\item{min_rel_diff}{this function only plots
parameters that lead to a relative change in the outcome greater than or equal
to \code{min_rel_diff}, which must be between 0 and 1. The default (0) is that
no strategies are filtered.}

\item{col}{either none, full color, or black and white}

\item{n_y_ticks}{number of y-axis ticks}

\item{ylim}{vector of y-axis limits, or NULL, which sets limits automatically}

\item{ybreaks}{vector of y-axis breaks.
will override \code{n_y_ticks} if provided.}
}
\value{
If \code{return == "plot"}, a \code{ggplot2} tornado plot derived from the \code{owsa}
object, or if \code{return == "data"}, a \code{data.frame} containing all data contained in the plot.
A tornado plot is a visual aid used to identify which parameters are driving most of the variation
in a specified model outcome.
}
\description{
Tornado plot of a one-way sensitivity analysis
}
