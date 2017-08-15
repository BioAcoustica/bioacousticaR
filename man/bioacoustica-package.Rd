\name{bioacoustica-package}
\alias{bioacoustica-package}
\alias{bioacoustica}
\docType{package}
\title{
Package to enable the querying of BioAcoustica from within R.
}
\description{
Request metadata and audio recordings from BioAcoustica's online collection of annotated wildlife sounds (http://bio.acousti/ca).
}
\details{
\tabular{ll}{
Package: \tab bioacoustica\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2014-12-17\cr
License: \tab GPL-2\cr
}
\link{bioacoustica.getAnnotations} is used to request a filtered list of annotations.
}
\author{
Ed Baker

Maintainer: Ed Baker <ed@ebaker.me.uk>
}
\references{
http://bio.acousti.ca/R
}
\examples{
\dontrun{
  wing <- bioacoustica.getAnnotations(taxon="Heteropteryx dilatata", type="Threat Response");
}
}
