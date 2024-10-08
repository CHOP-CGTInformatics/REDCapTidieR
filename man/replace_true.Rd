% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/combine_checkboxes.R
\name{replace_true}
\alias{replace_true}
\title{Replace checkbox TRUEs with raw_or_label values}
\usage{
replace_true(col, col_name, metadata, raw_or_label)
}
\arguments{
\item{col}{A vector}

\item{col_name}{A string}

\item{metadata}{A metadata tibble from the original supertibble}

\item{raw_or_label}{Either 'raw' or 'label' to specify whether to use raw coded
values or labels for the options. Default 'label'.}
}
\value{
A character string
}
\description{
Simple utility function for replacing checkbox field values.
}
\keyword{internal}
