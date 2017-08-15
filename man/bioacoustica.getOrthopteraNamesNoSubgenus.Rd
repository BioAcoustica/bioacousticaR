\name{bioacoustica.getOrthopteraNamesNoSubgenus}
\alias{bioacoustica.getOrthopteraNamesNoSubgenus}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Get list of Orthoptera taxa from BioAcoustica with no subgenera.
}
\description{
Used by the AAO project.
}
\usage{
bioacoustica.getOrthopteraNamesNoSubgenus(c)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{c}{
  An authenticated CURL handle.
  }
}
%\details{
%%  ~~ If necessary, more details than the description above ~~
%}
\value{
A list of names.
}
%\references{
%% ~put references to the literature/web site here ~
%}
\author{
Ed Baker
}
%\note{
%%  ~~further notes~~
%}

%% ~Make other sections like Warning with \section{Warning }{....} ~

%\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
%}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
bioacoustica.getOrthopteraNamesNoSubgenus <- function(c) {
  ba_names <- unique(read.csv(text = DrupalR::drupalr.get("http://bio.acousti.ca/", "aao/orthoptera", c)))
  ba_subspecies <- unique(read.csv(text = DrupalR::drupalr.get("http://bio.acousti.ca/", "aao/orthoptera/subspecies", c)))
  ba_names <- rbind(ba_names, ba_subspecies)
  ba_names$SupertreeTaxon <- gsub(' ', '_', ba_names$SupertreeTaxon)
  return(ba_names)
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
%\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
