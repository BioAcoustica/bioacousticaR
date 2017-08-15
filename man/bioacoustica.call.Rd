\name{bioacoustica.call}
\alias{bioacoustica.call}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Helper function to request data from BioAcoustica.
}
\description{
This function is used (primarily but not exclusively by other package functions)
to download a HTML of other object from BioAcoustica.
}
\usage{
bioacoustica.call(path)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{path}{
  Thepath of the ocntent ot retrieve.
  }
}
%\details{
%%  ~~ If necessary, more details than the description above ~~
%}
\value{
A string containing the HTML or other content retrieved.
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
function(path) {
  message(paste0(bioacoustica.getHandle(), path));
  download <- DrupalR::drupalr.get(bioacoustica.getHandle(), path);
  return (read.csv(text = download));
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
%\keyword{ ~kwd1 }
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
