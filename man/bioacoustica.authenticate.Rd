\name{bioacoustica.authenticate}
\alias{bioacoustica.authenticate}

\title{
Authenticate to BioAcoustica.
}
\description{
This function allows youto authenticate to BiOAcoustica using your crednetials from within R.
}
\usage{
bioacoustica.authenticate(username, password)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{username}{
  Your BioAcoustica user name.
  }
  \item{password}{
  Your BioAcoustica password.
  }
}
%\details{
%%  ~~ If necessary, more details than the description above ~~
%}
\value{
An authenticated CURL handle that can be passed to other functions in this package.
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
function(username, password) {
  return(DrupalR::drupalr.authenticate(bioacoustica::bioacoustica.getHandle(), username, password));  
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
%\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
