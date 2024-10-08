% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ceac.R
\name{plot.ceac}
\alias{plot.ceac}
\title{Plot of Cost-Effectiveness Acceptability Curves (CEAC)}
\usage{
\method{plot}{ceac}(
  x,
  frontier = TRUE,
  points = TRUE,
  currency = "$",
  min_prob = 0,
  txtsize = 12,
  n_x_ticks = 10,
  n_y_ticks = 8,
  xbreaks = NULL,
  ybreaks = NULL,
  ylim = NULL,
  xlim = c(0, NA),
  col = c("full", "bw"),
  ...
)
}
\arguments{
\item{x}{object of class \code{ceac}.}

\item{frontier}{whether to plot acceptability frontier (TRUE) or not (FALSE)}

\item{points}{whether to plot points (TRUE) or not (FALSE)}

\item{currency}{string with currency used in the cost-effectiveness analysis (CEA).
Defaults to \code{$}, but can be any currency symbol or word (e.g., £, €, peso)}

\item{min_prob}{minimum probability to show strategy in plot.
For example, if the min_prob is 0.05, only strategies that ever
exceed Pr(Cost Effective) = 0.05 will be plotted. Most useful in situations
with many strategies.}

\item{txtsize}{base text size}

\item{n_x_ticks}{number of x-axis ticks}

\item{n_y_ticks}{number of y-axis ticks}

\item{xbreaks}{vector of x-axis breaks.
will override \code{n_x_ticks} if provided.}

\item{ybreaks}{vector of y-axis breaks.
will override \code{n_y_ticks} if provided.}

\item{ylim}{vector of y-axis limits, or NULL, which sets limits automatically}

\item{xlim}{vector of x-axis limits, or NULL, which sets limits automatically}

\item{col}{either none, full color, or black and white}

\item{...}{further arguments to plot.
This is not used by \code{dampack} but required for generic consistency.}
}
\value{
A \code{ggplot2} plot of the CEAC.
}
\description{
Plots the CEAC, using the object created by \code{\link{ceac}}.
}
\details{
\code{ceac} computes the probability of each of the strategies being
cost-effective at each \code{wtp} value.
}
\keyword{internal}
