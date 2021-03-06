% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lrt.R
\name{lrt}
\alias{lrt}
\alias{lrt.mds_ts}
\alias{lrt.default}
\title{Likelihood Ratio Rest}
\usage{
lrt(df, ...)

\method{lrt}{mds_ts}(df, ts_event = c(Count = "nA"), analysis_of = NA, ...)

\method{lrt}{default}(
  df,
  analysis_of = NA,
  eval_period = 1,
  alpha = 0.05,
  mc_sample = 10000,
  ...
)
}
\arguments{
\item{df}{Required input data frame of class \code{mds_ts} or, for generic
usage, any data frame with the following columns:
\describe{
  \item{time}{Unique times of class \code{Date}}
  \item{nA}{Cell A count (class \code{numeric}) of the 2x2 table:
  device/event of interest.}
  \item{nB}{Cell B count (class \code{numeric}) of the 2x2 table:
  device/non-event of interest.}
  \item{nC}{Cell C count (class \code{numeric}) of the 2x2 table:
  non-device/event of interest.}
  \item{nD}{Cell D count (class \code{numeric}) of the 2x2 table:
  non-device/non-event of interest.}
}}

\item{...}{Further arguments passed onto \code{lrt} methods}

\item{ts_event}{Required if \code{df} is of class \code{mds_ts}. Named string
indicating the variable corresponding to the event count (cell A in the 2x2
contingency table). In most cases, the default is the appropriate setting.
See details for alternative options.

Default: \code{c("Count"="nA")} corresponding to the event count column in
\code{mds_ts} objects. Name is generated from \code{mds_ts} metadata.}

\item{analysis_of}{Optional string indicating the English description of what
was analyzed. If specified, this will override the name of the
\code{ts_event} string parameter.

Default: \code{NA} indicates no English description for plain \code{df}
data frames, or \code{ts_event} English description for \code{df} data frames
of class \code{mds_ts}.

Example: \code{"Count of bone cement leakages"}}

\item{eval_period}{Required positive integer indicating the number of unique
times counting in reverse chronological order to sum over to create the 2x2
contingency table.

Default: \code{1} considers only the most recent time in \code{df}.

Example: \code{12} sums over the last 12 time periods to create the 2x2
contingency table.}

\item{alpha}{Alpha or Type-I error rate in the range (0, 1), used to
determine signal status.
It is the threshold for determining if the observed reporting rate is
greater than the expected based on Monte Carlo simulations of the null.

Default: \code{0.05} is an alpha level of 0.05 or 5\%.}

\item{mc_sample}{Number of Monte Carlo samples for constructing the
null distribution based on empirical data. Lowest recommended is 1000.
Increasing iterations also increases p-value precision.

Default: \code{10000} uses 10000 bootstrap iterations.}
}
\value{
A named list of class \code{mdsstat_test} object, as follows:
\describe{
  \item{test_name}{Name of the test run}
  \item{analysis_of}{English description of what was analyzed}
  \item{status}{Named boolean of whether the test was run. The name contains
  the run status.}
  \item{result}{A standardized list of test run results: \code{statistic}
  for the test statistic, \code{lcl} and \code{ucl} for the set
  confidence bounds, \code{p} for the p-value, \code{signal} status, and
  \code{signal_threshold}.}
  \item{params}{The test parameters}
  \item{data}{The data on which the test was run}
}
}
\description{
Test on device-events using the Likelihood Ratio Test, originally proposed by
Huang & Tiwari (2011). From
the family of disproportionality analyses (DPA) used to generate signals of
disproportionate reporting (SDRs).
}
\details{
This is an implementation of the "Regular LRT" per
Huang & Tiwari (2019). It assumes a test on a single event of interest
where all other events & devices are collapsed, effectively testing a 2x2
table only. Therefore this is a test on the significance of the likelihood
ratio instead of the maximum likelihood over \code{i} events for a given
medical product \code{j} (refer to Huang & Tiwari, 2011).

For parameter \code{ts_event}, in the uncommon case where the
device-event count (Cell A) variable is not \code{"nA"}, the name of the
variable may be specified here. Note that the remaining 3 cells of the 2x2
contingency table (Cells B, C, D) must be the variables \code{"nB"},
\code{"nC"}, and \code{"nD"} respectively in \code{df}. A named character
vector may be used where the name is the English description of what was
analyzed. Note that if the parameter \code{analysis_of} is specified, it will
override this name. Example: \code{ts_event=c("Count of Bone Cement
Leakages"="event_count")}
}
\section{Methods (by class)}{
\itemize{
\item \code{mds_ts}: LRT on mds_ts data

\item \code{default}: LRT on general data
}}

\examples{
# Basic Example
data <- data.frame(time=c(1:25),
                   nA=as.integer(stats::rnorm(25, 25, 5)),
                   nB=as.integer(stats::rnorm(25, 50, 5)),
                   nC=as.integer(stats::rnorm(25, 100, 25)),
                   nD=as.integer(stats::rnorm(25, 200, 25)))
a1 <- lrt(data)
# Example using an mds_ts object
a2 <- lrt(mds_ts[[3]])

}
\references{
Huang L, Zalkikar J, Tiwari RC. A Likelihood Ratio Test Based Method for Signal Detection with Application to FDA’s Drug Safety Data. Journal of the American Statistical Association, 2011, Volume 106, Issue 496, 1230-1241.

Huang L, Zalkikar J, Tiwari RC. Likelihood-Ratio-Test Methods for Drug Safety Signal Detection from Multiple Clinical Datasets. Comput Math Methods Med. 2019, PMC6399568.
}
