\name{bioacoustica.getAnnotations}
\alias{bioacoustica.getAnnotations}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Function to request annotated sections of recordings from BioAcoustica.
}
\description{
This function is used to get annotation information form the BioAcoustica database, based on the taxon fetaured in the annotated section and the type of annotation. By default this function performs checks that the requested taxa and types are valid, for faster operation the checks can be skipped.
}
\usage{
bioacoustica.getAnnotations(taxon = NULL, type = NULL, skipcheck = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{taxon}{
  A taxon name can be passed to the function to filter annotations to that taxon and its children.
  }
  \item{type}{
  An annotation type can be passed to the function to filter anootations to that type.
  }
  \item{skipcheck}{
  If set to TRUE the taxon and type filters will not be checked before filtering.
  }
}
%\details{
%%  ~~ If necessary, more details than the description above ~~
%}
\value{
CSV file a string.
%\references{
%% ~put references to the literature/web site here ~
%}
\author{
Ed Baker
}
%\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

%\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
%}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function(taxon=NULL, type=NULL, skipcheck=FALSE) {
  path <- "/R/annotations";
  annotations <- bioacoustica::bioacoustica.call(path);
  return (annotations);
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
%\keyword{ ~kwd1 }
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
