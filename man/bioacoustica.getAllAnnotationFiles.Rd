\name{bioacoustica.getAllAnnotationFiles}
\alias{bioacoustica.getAllAnnotationFiles}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Download all annotated segments from BioAcoustica
}
\description{
Downloads all annotated sections of sound recording from BioAcoustica into the ./data directory.
}
\usage{
bioacoustica.getAllAnnotationFiles(c)
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
All files are downloaded into the ./data directory.
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

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
%\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
