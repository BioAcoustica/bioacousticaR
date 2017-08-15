\name{bioacoustica.getAnnotationFile}
\alias{bioacoustica.getAnnotationFile}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Downloads an annotated section of a recording
}
\description{
This fucntion wil download and trim a recording to match an annotated section of recording on BioAcoustica.
}
\usage{
bioacoustica.getAnnotationFile(annotation_id, c)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{annotation_id}{
  The annotation ID of the annotation on BioAcoustica.
  }
  \item{c}{
  An authenticated CURL handle.
  }
}
%\details{
%%  ~~ If necessary, more details than the description above ~~
%}
\value{
The filename to a downloaded sound recording.
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
function(annotation_id, c) {
  a <- bioacoustica::bioacoustica.getAnnotations(c);
  file <- as.character(subset(a, 
                              a$id==annotation_id,
                              select="file")[1,1]);
  parts <- strsplit(file, "/");
  filename <- parts[[1]][7];
  #TODO: CHange to CURL
  download.file(file, destfile=filename);
  long <- tuneR::readWave(filename);
  f <- long@samp.rate;
  wave <- seewave::cutw(long, f=f, from=subset(a, id==annotation_id,
                          select="start")[1,1], 
                          to=subset(a, id==annotation_id,select="end")[1,1],
                          method="Wave");
  file.remove(filename);
  nf <- paste0(filename,".",annotation_id,".wav");
  seewave::savewav(wave, f=f, file=nf);
  return(nf)
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
%\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
