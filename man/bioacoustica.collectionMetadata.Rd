\name{bioacoustica.collectionMetadata}
\alias{bioacoustica.collectionMetadata}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
BioAcoustica Collection Metadata
}
\description{
Retrieves the metadata for a collection of recordings
}
\usage{
bioacoustica.collectionMetadata(collectionID, c)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{collectionID}{
  The BioAcoustica collection ID of the collection to retrieve.
  }
  \item{c}{
  An authenticated CURL handle.
  }
}
%\details{
%%  ~~ If necessary, more details than the description above ~~
%}
\value{
A string of the CSV metadata.
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
function(collectionID, c) {
  collection <- read.csv(text=DrupalR::drupalr.get("bio.acousti.ca/", paste0("collection/csv/",collectionID,"/", collectionID), c))
  return(collection)
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
%\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
