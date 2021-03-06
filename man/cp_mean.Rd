% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cp_mean.R
\name{cp_mean}
\alias{cp_mean}
\alias{cp_mean.mds_ts}
\alias{cp_mean.default}
\title{Mean-Shift Changepoint}
\usage{
cp_mean(df, ...)

\method{cp_mean}{mds_ts}(df, ts_event = c(Count = "nA"), analysis_of = NA, ...)

\method{cp_mean}{default}(
  df,
  analysis_of = NA,
  eval_period = NULL,
  alpha = 0.05,
  cp_max = 100,
  min_seglen = 6,
  epochs = NULL,
  bootstrap_iter = 1000,
  replace = T,
  zero_rate = 1/3,
  ...
)
}
\arguments{
\item{df}{Required input data frame of class \code{mds_ts} or, for generic
usage, any data frame with the following columns:
\describe{
  \item{time}{Unique times of class \code{Date}}
  \item{event}{Either the event count or rate of class \code{numeric}}
}}

\item{...}{Further arguments passed onto \code{cp_mean} methods}

\item{ts_event}{Required if \code{df} is of class \code{mds_ts}. Named string
indicating the variable corresponding to the event count or rate. Rate must
be calculated in a separate column in \code{df} as it is not calculated by
default. The name of the string is an English description of what was
analyzed.

Default: \code{c("Count"="nA")} corresponding to the event count column in
\code{mds_ts} objects. Name is generated from \code{mds_ts} metadata.

Example: \code{c("Rate of Bone Filler Events in Canada"="rate")}}

\item{analysis_of}{Optional string indicating the English description of what
was analyzed. If specified, this will override the name of the
\code{ts_event} string parameter.

Default: \code{NA} indicates no English description for plain \code{df}
data frames, or \code{ts_event} English description for \code{df} data frames
of class \code{mds_ts}.

Example: \code{"Rate of bone cement leakage"}}

\item{eval_period}{Optional positive integer indicating the number of unique
times counting in reverse chronological order to assess. This will be used to
establish the process mean and moving range.

Default: \code{NULL} considers all times in \code{df}.}

\item{alpha}{Alpha or Type-I error rate for detection of a changepoint, in
the range (0, 1).

Default: \code{0.05} detects a changepoint at an alpha level of 0.05 or 5\%.}

\item{cp_max}{Maximum number of changepoints detectable. This supersedes the
theoretical max set by \code{epochs}.

Default: \code{100} detects up to a maximum of 100 changepoints.}

\item{min_seglen}{Minimum required length of consecutive measurements without
a changepoint in order to test for an additional changepoint within.

Default: \code{6} requires a minimum of 6 consecutive measurements.}

\item{epochs}{Maximum number of epochs allowed in the iterative search for
changepoints, where \code{2^epochs} is the theoretical max changepoints
findable. Within each epoch, all measurement segments with a minimum of
\code{min_seglen} measurements are tested for a changepoint until no
additional changepoints are found.

Default: \code{NULL} estimates max epochs from the number of observations or
measurements in \code{df} and \code{min_seglen}.}

\item{bootstrap_iter}{Number of bootstrap iterations for constructing the
null distribution of means. Lowest recommended is 1000. Increasing iterations
also increases p-value precision.

Default: \code{1000} uses 1000 bootstrap iterations.}

\item{replace}{When sampling for the bootstrap, perform sampling with or
without replacement. Unless your \code{df} contains many measurements, and
definitely more than \code{bootstrap_iter}, it makes the most sense to set
this to \code{TRUE}.

Default: \code{T} constructs bootstrap samples with replacement.}

\item{zero_rate}{Required maximum proportion of \code{event}s in \code{df}
(constrained by \code{eval_period}) containing zeroes for this algorithm to
run. Because mean-shift changepoint does not perform well on time series with
many 0 values, a value >0 is recommended.

Default: \code{1/3} requires no more than 1/3 zeros in \code{event}s in
\code{df} in order to run.}
}
\value{
A named list of class \code{mdsstat_test} object, as follows:
\describe{
  \item{test_name}{Name of the test run}
  \item{analysis_of}{English description of what was analyzed}
  \item{status}{Named boolean of whether the test was run. The name contains
  the run status.}
  \item{result}{A standardized list of test run results: \code{statistic}
  for the test statistic, \code{lcl} and \code{ucl} for the 95%
  confidence bounds, \code{p} for the p-value, \code{signal} status, and
  \code{signal_threshold}.}
  \item{params}{The test parameters}
  \item{data}{The data on which the test was run}
}
}
\description{
Test on device-events using the mean-shift changepoint method
originally described in Xu, et al 2015.
}
\details{
Function \code{cp_mean()} is an implementation of the mean-shift changepoint
method originally proposed by Xu, et al (2015) based on testing the
mean-centered absolute cumulative sum against a bootstrap null
distribution. This algorithm defines a signal as any changepoint found within
the last/most recent n=\code{min_seglen} measurements of \code{df}.

The parameters in this implementation can be interpreted as
follows. Changepoints are detected at an \code{alpha} level based on
n=\code{bootstrap_iter} bootstrap iterations (with or without replacement
using \code{replace}) of the input time series
\code{df}. A minimum of n=\code{min_seglen} consecutive measurements without
a changepoint are required to test for an additional changepoint. Both
\code{epochs} and \code{cp_max} constrain the maximum possible number of
changepoints detectable as follows: within each epoch, each segment of
consecutive measurements at least n=\code{min_seglen} measurements long are
tested for a changepoint, until no additional changepoints are found.
}
\section{Methods (by class)}{
\itemize{
\item \code{mds_ts}: Mean-shift changepoint on mds_ts data

\item \code{default}: Mean-shift changepoint on general data
}}

\examples{
# Basic Example
data <- data.frame(time=c(1:25), event=as.integer(stats::rnorm(25, 100, 25)))
a1 <- cp_mean(data)
# Example using an mds_ts object
a2 <- cp_mean(mds_ts[[3]])
# Example using a derived rate as the "event"
data <- mds_ts[[3]]
data$rate <- ifelse(is.na(data$nA), 0, data$nA) / data$exposure
a3 <- cp_mean(data, c(Rate="rate"))

}
\references{
Xu, Zhiheng, et al. "Signal detection using change point analysis in postmarket surveillance." Pharmacoepidemiology and Drug Safety 24.6 (2015): 663-668.
}
