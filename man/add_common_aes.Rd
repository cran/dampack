% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/add_common_aes.R
\name{add_common_aes}
\alias{add_common_aes}
\title{Adds aesthetics to all plots to reduce code duplication}
\usage{
add_common_aes(
  gplot,
  txtsize,
  scale_name = waiver(),
  col = c("none", "full", "bw"),
  col_aes = c("fill", "color"),
  lval = 50,
  greystart = 0.2,
  greyend = 0.8,
  continuous = c("none", "x", "y"),
  n_x_ticks = 6,
  n_y_ticks = 6,
  xbreaks = NULL,
  ybreaks = NULL,
  xlim = NULL,
  ylim = NULL,
  xtrans = "identity",
  ytrans = "identity",
  xexpand = waiver(),
  yexpand = waiver(),
  facet_lab_txtsize = NULL,
  ...
)
}
\arguments{
\item{gplot}{a ggplot object}

\item{txtsize}{base text size}

\item{scale_name}{how to name scale. Default inherits from variable name.}

\item{col}{either none, full color, or black and white}

\item{col_aes}{which aesthetics to modify with \code{col}}

\item{lval}{color lightness - 0 to 100}

\item{greystart}{between 0 and 1. used in greyscale only. smaller numbers are lighter}

\item{greyend}{between 0 and 1, greater than greystart.}

\item{continuous}{which axes are continuous and should be modified by this function}

\item{n_x_ticks}{number of x-axis ticks}

\item{n_y_ticks}{number of y-axis ticks}

\item{xbreaks}{vector of x-axis breaks.
will override \code{n_x_ticks} if provided.}

\item{ybreaks}{vector of y-axis breaks.
will override \code{n_y_ticks} if provided.}

\item{xlim}{vector of x-axis limits, or NULL, which sets limits automatically}

\item{ylim}{vector of y-axis limits, or NULL, which sets limits automatically}

\item{xtrans}{transformation for the x-axis. See \code{\link[ggplot2]{scale_continuous}} for details.}

\item{ytrans}{transformation for the y-axis. See \code{\link[ggplot2]{scale_continuous}} for details.}

\item{xexpand}{Padding around data. See \code{\link[ggplot2]{scale_continuous}} for details.}

\item{yexpand}{Padding around data. See \code{\link[ggplot2]{scale_continuous}} for details.
The default behavior in ggplot2 is \code{expansion(0.05)}. See \code{\link[ggplot2]{expansion}}
for how to modify this.}

\item{facet_lab_txtsize}{text size for plot facet labels}

\item{...}{further arguments to plot.
This is not used by \code{dampack} but required for generic consistency.}
}
\value{
a \code{ggplot2} plot updated with a common aesthetic
}
\description{
Adds aesthetics to all plots to reduce code duplication
}
\keyword{internal}
