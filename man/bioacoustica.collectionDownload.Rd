\name{bioacoustica.collectionDownload}
\alias{bioacoustica.collectionDownload}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
BioAcoustica collection download
}
\description{
Downlaods the recordings from a BioAcoustica collection.
}
\usage{
bioacoustica.collectionDownload(collectionID, c)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{collectionID}{
  The BioAcoustica collection ID of the collection to download.
  }
  \item{c}{
  An authenticated CURL handle.
  }
}
%\details{
%%  ~~ If necessary, more details than the description above ~~
%}
%\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
%}
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
  collection <- NULL;
  if (typeof(collectionID) != "list") {
    collection <- read.csv(text=DrupalR::drupalr.get("bio.acousti.ca/", paste0("collection/csv/",collectionID,"/", collectionID), c))
  } else {
    collection <- collectionID
  }
  bioacoustica.mkdir("bioacoustica_data")
  
  downloadData <- function(data, name) {
    url <- data["recording_url"]
    filename <- paste0(data["entity_id"],".wav")
    download.file(url, filename)
    
    if (data["entity_type"] == "annotation") {
      trimFile(filename, data["start"], data["end"])
    }
  }
  
  trimFile <- function(filename, start, end) {
    long <- readWave(filename)
    f <- long@samp.rate
    short <- seewave::cutw(long, f=f, from=as.numeric(start),to=as.numeric(end), method="Wave")
    file.remove(filename)
    seewave::savewav(short, f=f, file=filename)
  }
  
  urls <- as.character(collection[,"recording_url"])
  filenames <- as.character(collection[,"entity_id"])
  setwd("./bioacoustica_data")
  apply(collection, 1, downloadData)
  setwd("..")
  
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
%\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
