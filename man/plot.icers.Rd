% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/icers.R
\name{plot.icers}
\alias{plot.icers}
\title{Plot of ICERs}
\usage{
\method{plot}{icers}(
  x,
  txtsize = 12,
  currency = "$",
  effect_units = "QALYs",
  label = c("frontier", "all", "none"),
  label_max_char = NULL,
  plot_frontier_only = FALSE,
  alpha = 1,
  n_x_ticks = 6,
  n_y_ticks = 6,
  xbreaks = NULL,
  ybreaks = NULL,
  xlim = NULL,
  ylim = NULL,
  xexpand = expansion(0.1),
  yexpand = expansion(0.1),
  max.iter = 20000,
  ...
)
}
\arguments{
\item{x}{Object of class \code{icers}.}

\item{txtsize}{base text size}

\item{currency}{string. with currency used in the cost-effectiveness analysis (CEA).}

\item{effect_units}{string. unit of effectiveness}

\item{label}{whether to label strategies on the efficient frontier, all strategies, or none.
defaults to frontier.}

\item{label_max_char}{max number of characters to label the strategies - if not NULL (the default)
longer strategies are truncated to save space.}

\item{plot_frontier_only}{only plot the efficient frontier}

\item{alpha}{opacity of points}

\item{n_x_ticks}{number of x-axis ticks}

\item{n_y_ticks}{number of y-axis ticks}

\item{xbreaks}{vector of x-axis breaks.
will override \code{n_x_ticks} if provided.}

\item{ybreaks}{vector of y-axis breaks.
will override \code{n_y_ticks} if provided.}

\item{xlim}{vector of x-axis limits, or NULL, which sets limits automatically}

\item{ylim}{vector of y-axis limits, or NULL, which sets limits automatically}

\item{xexpand}{Padding around data. See \code{\link[ggplot2]{scale_continuous}} for details.}

\item{yexpand}{Padding around data. See \code{\link[ggplot2]{scale_continuous}} for details.
The default behavior in ggplot2 is \code{expansion(0.05)}. See \code{\link[ggplot2]{expansion}}
for how to modify this.}

\item{max.iter}{Maximum number of iterations to try to resolve overlaps.
Defaults to 10000.}

\item{...}{further arguments to plot.
This is not used by \code{dampack} but required for generic consistency.}
}
\value{
a ggplot2 object which can be modified by adding additional geoms
}
\description{
Plots the cost-effectiveness plane for a ICER object, calculated with \code{\link{calculate_icers}}
}
