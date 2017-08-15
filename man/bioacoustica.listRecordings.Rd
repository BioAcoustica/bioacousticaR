\name{bioacoustica.listRecordings}
\alias{bioacoustica.listRecordings}

\title{
List Recordings
}
\description{
Function to list recordings available on BioAcoustica, optionally filtered by taxon.
}
\usage{
bioacoustica.listRecordings(taxon=NULL, children=FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{taxon}{
  The BioAcoustica taxon ID to filter by.
  }
  \item{children}{
  If set to TRUE recordings of taxonomic children of the taxon will also be returned.
  }
}
%\details{
%%  ~~ If necessary, more details than the description above ~~
%}
\value{
String of CSV of returned data.
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
function(taxon=NULL, children=FALSE) {
  if (is.null(taxon)) {
    taxon <- "";
  } else {
    taxon <- sub(" ", "+", taxon)
  }
  if(!children) {
    path <- paste0("/R/recordings/", taxon);
  } else {
    path <- paste0("/R/recordings-depth/", taxon);
  }
  return (bioacoustica::bioacoustica.call(path));
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
%\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
