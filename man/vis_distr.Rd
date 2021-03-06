% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/low-level-interface-distr.R
\name{vis_distr}
\alias{vis_distr}
\alias{vis_1d_distr}
\alias{vis_2d_distr}
\title{Plot a distribution}
\usage{
vis_distr(data, aes, name = aes, geom = NULL, fill = "gray60", ...)

vis_1d_distr(data, aes, name = aes, geom = NULL, fill = "gray60", ...)

vis_2d_distr(data, aes, name = aes, geom = NULL, fill = "gray60", ...)
}
\arguments{
\item{data}{A data frame with data to visualize.}

\item{aes}{A string to indicate the column for which a distribution should
be shown.}

\item{name}{The name of the variable to plot. If \code{NULL} (the default), the
name is inferred form \code{aes}.}

\item{geom}{The bare name of the geom to use. If \code{NULL} (the default),
it is determined by the class of the data to plot.}

\item{fill}{The color to fill the density area with.}

\item{...}{Passed to the geom. See 'Details'.}
}
\description{
Functions to create a distribution plot to be sent to the console or written
to a file.
}
\details{
All functions documented here are just a forwarder to \code{vis_distr} and the
reason for their existence is because when used as an input to \code{vis_cols},
the dimensions of the output can be derived from the name of the transformer,
so the argument \code{k_dimensional} does not have to be specified.
If the column has not the target class, you can convert one or multiple
columns easily with \code{\link[=transform_cols]{transform_cols()}}.
}
\examples{
vis_1d_distr(mtcars, aes = "cyl") \%>\%
  flatten_gg()
vis_distr(mtcars, aes = c("cyl", "vs")) \%>\%
  flatten_gg()
}
