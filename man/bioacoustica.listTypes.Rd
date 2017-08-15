\name{bioacoustica.listTypes}
\alias{bioacoustica.listTypes}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Function listing allowed annotation types from BioAcoustica
}
\description{
This function lists the annotation types that are currently available on BioAcoustica.
}
\usage{
bioacoustica.listTypes()
}
%- maybe also 'usage' for other objects documented here.
%\details{
%%  ~~ If necessary, more details than the description above ~~
%}
\value{
CSV file of the annotation types.
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
function () 
{
    url <- "http://bio.acousti.ca/R/types"
    types <- bioacoustica.call(url)
    return(types)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
%\keyword{ ~kwd1 }
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
