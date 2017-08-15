\name{bioacoustica.listTraits}
\alias{bioacoustica.listTraits}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Function to list traits present on BioAcoustica
}
\description{
This function is used to list the trait data available on BioAcoustica.
}
\usage{
bioacoustica.listTraits(c)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{c}{
  Optionally provide an authenticated CURL handler.
  }
}
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
function(c) {
  message("Traits file is large and generated on cron, it may lag behind website data.")
  path <- "/files/traits/bioacoustic-traits.txt";
  ba_traits <- bioacoustica::bioacoustica.call(path);
  return (ba_traits);
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
%\keyword{ ~kwd1 }
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
