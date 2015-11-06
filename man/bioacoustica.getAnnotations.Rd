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
%%     ~~Describe \code{taxon} here~~
}
  \item{type}{
%%     ~~Describe \code{type} here~~
}
  \item{skipcheck}{
%%     ~~Describe \code{skipcheck} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (taxon = NULL, type = NULL, skipcheck = FALSE) 
{
    if (is.null(taxon)) {
        taxon <- "?name="
    }
    else {
        if (skipcheck == TRUE || sum(sapply(bioacoustica.listTaxa(), 
            match, taxon, nomatch = 0)) == 1) {
            taxon <- sub(" ", "+", taxon)
            taxon <- paste("?name=", taxon, sep = "")
        }
        else {
            stop(paste(taxon, "is not a known taxon"))
        }
    }
    if (is.null(type)) {
        type <- "&name_1="
    }
    else {
        if (skipcheck == TRUE || sum(sapply(bioacoustica.listTypes(), 
            match, type, nomatch = 0)) == 1) {
            type <- sub(" ", "+", type)
            type <- paste("&name_1=", type, sep = "")
        }
        else {
            stop(paste(type, "is not a valid annotation type"))
        }
    }
    url <- paste("http://bio.acousti.ca/R/annotations", taxon, 
        type, sep = "")
    annotations <- bioacoustica.call(url)
    return(annotations)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
