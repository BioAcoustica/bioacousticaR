\name{bioacoustica.postAnnotation}
\alias{bioacoustica.postAnnotation}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Post an annotation to BioAcoustica
}
\description{
Function to post a new annotation to the BioAcoustica repository.
}
\usage{
bioacoustica.postAnnotation(path, type, taxon, start, end, c)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{path}{
  Relative path to the recording you wish to annotate.
  }
  \item{type}{
  The type of annotation you wish to make.
  }
  \item{taxon}{
  Taxa present in the annotated section.
  }
  \item{start}{
  Start time of annotated section in seconds.
  }
  \item{end}{
  End time of annotated section in seconds.
  }
  \item{c}{
  Authenticated CURL handle.
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
function(path, type, taxon, start, end, c) {
  type_id <- as.character(subset(bioacoustica::bioacoustica.listTypes(), Type==type, select=Term.ID)[1,])
  extra_pars = list(
    'field_type[und]' = type_id,
    'field_taxonomic_name[und]' = taxon,
    'field_start_time[und][0][value]' = start,
    'field_end_time[und][0][value]' = end
  );
  DrupalR::drupalr.postComment(bioacoustica::bioacoustica.getHandle(), path, '', extra_pars, c);
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
