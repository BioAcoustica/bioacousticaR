\name{bioacoustica.listCollections}
\alias{bioacoustica.listCollections}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Function to list collections present on BioAcoustica
}
\description{
This function is used to list collections available on BioAcoustica.
}
\usage{
bioacoustica.listCollections()
}
%- maybe also 'usage' for other objects documented here.
%\arguments{
%  Optionally provide an authenticated CURL handler.
%  }
%}
%\details{
%%  ~~ If necessary, more details than the description above ~~
%}
\value{
String of CSV data.
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
function() {
  path <- "/R/collections";
  collections <- bioacoustica::bioacoustica.call(path);
  return (collections);
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
%\keyword{ ~kwd1 }
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
