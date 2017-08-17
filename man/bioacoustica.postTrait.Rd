\name{bioacoustica.postTrait}
\alias{bioacoustica.postTrait}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Post trait data to BioAcoustica
}
\description{
A function to post bioacoustic traits to BioAcoustica.
}
\usage{
bioacoustica.postTrait(taxon_name, c, call_type="", trait="", value="", temp="", sex="", inference_notes="", cascade=0)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{taxon_name}{
  Thetaxonomic name of the species the trait belongs to.
  }
  \item{c}{
  An authenticated CURL handle.
  }
  \item{call_type}{
  The type of call the trait applies to (e.g. calling song, rivalry song).
  }
  \item{trait}{
  The name of the trait being submitted.
  }
  \item{value}{
  The value of the trait being submitted.
  }
  \item{temp}{
  The temperature at which the trait was recorded.
  }
  \item{sex}{
  The sex of the individual the trait applies to.
  }
  \item{inference_notes}{
  String describing how the trait was infered, if applicable.
  }
  \item{cascade}{
  If set to 1 the BioAcoustica inference bot will aplly this trait to child taxa of this taxon.
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
function(taxon_name, c, call_type=NULL, trait=NULL, value=NULL, temp=NULL, sex=NULL, inference_notes=NULL, cascade=0){
  pars=list(
    "group_audience[und][]"=2,
    "group_content_access[und]"=2,
    "field_taxonomic_name[und]"=taxon_name,
    "field_bioacoustic_traits[und][0][field_call_type][und][0][value]"=call_type,
    "field_bioacoustic_traits[und][0][field_trait][und]"=trait,
    "field_bioacoustic_traits[und][0][field_value][und][0][value]"=value,
    "field_bioacoustic_traits[und][0][field_temperature][und][0][value]"=temp,
    "field_bioacoustic_traits[und][0][field_sex_trait][und][0][value]"=sex,
    "field_inference_notes[und][0][value]"=inference_notes
  )
  if (cascade==1) {
    pars <-c(pars, "field_bioacoustic_traits[und][0][field_cascade_down][und]"=1)
  }
  DrupalR::drupalr.postForm("bio.acousti.ca", "/node/add/bioacoustic-traits", "bioacoustic-traits-node-form", pars=pars, c)
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
%\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
