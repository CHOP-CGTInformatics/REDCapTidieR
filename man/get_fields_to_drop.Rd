% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_redcap.R
\name{get_fields_to_drop}
\alias{get_fields_to_drop}
\title{Determine fields included in \code{REDCapR::redcap_read_oneshot} output
that should be dropped from results of \code{read_redcap}}
\usage{
get_fields_to_drop(db_metadata, form)
}
\arguments{
\item{db_metadata}{metadata tibble created by
\code{REDCapR::redcap_metadata_read}}

\item{form}{the name of the instrument containing identifiers}
}
\value{
A character vector of extra field names that can be used to filter the
results of \code{REDCapR::redcap_read_oneshot}
}
\description{
Determine fields included in \code{REDCapR::redcap_read_oneshot} output
that should be dropped from results of \code{read_redcap}
}
\details{
This function applies rules to determine which fields are included in the
results of \code{REDCapR::redcap_read_oneshot} because the user didn't
request the instrument containing identifiers
}
\keyword{internal}
