% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{try_redcapr}
\alias{try_redcapr}
\title{Make a \code{REDCapR} API call with custom error handling}
\usage{
try_redcapr(expr, call = caller_env())
}
\arguments{
\item{expr}{an expression making a \code{REDCapR} API call}

\item{call}{the calling environment to use in the warning message}
}
\value{
If successful, the \code{data} element of the \code{REDCapR} result. Otherwise an error
}
\description{
Make a \code{REDCapR} API call with custom error handling
}
\keyword{internal}
