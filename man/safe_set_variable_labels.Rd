% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{safe_set_variable_labels}
\alias{safe_set_variable_labels}
\title{Safely set variable labels}
\usage{
safe_set_variable_labels(data, labs)
}
\value{
A tibble
}
\description{
A utility function for setting labels of a tibble from a named vector while
accounting for labels that may not be present in the data.
}
\keyword{internal}
