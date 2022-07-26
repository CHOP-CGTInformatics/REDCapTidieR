% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_redcap.R
\name{calc_metadata_stats}
\alias{calc_metadata_stats}
\title{Utility function to calculate summary for each tibble in a supertibble}
\usage{
calc_metadata_stats(data)
}
\arguments{
\item{data}{a tibble of redcap data stored in the \code{redcap_data} column
of a supertibble}
}
\value{
A list containing:
\itemize{
\item \code{data_rows}, the number of rows in the data
\item \code{data_cols}, the number of columns in the data
\item \code{data_size}, the size of the data in bytes
\item \code{data_na_pct}, the percentage of cells that are NA excluding
identifiers and form completion fields
}
}
\description{
Utility function to calculate summary for each tibble in a supertibble
}
\keyword{internal}
