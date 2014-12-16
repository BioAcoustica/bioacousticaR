library(RCurl);



bioacoustica.listTypes <- function() {
  url <- "http://bio.acousti.ca/R/types";
  types <- bioacoustica.call(url);
  return (types);
}

bioacoustica.listTaxa <- function() {
  url <- "http://bio.acousti.ca/R/taxa";
  taxa <- bioacoustica.call(url);
  return (taxa);
}

bioacoustica.getAnnotations <- function(taxon=NULL, type=NULL, skipcheck=FALSE) {
  if (is.null(taxon)) {
    taxon <- "?name=";
  } else {
    if (skipcheck == TRUE || sum(sapply(bioacoustica.listTaxa(), match, taxon, nomatch=0)) == 1) {
      taxon <- sub(" ", "+", taxon);
      taxon <- paste("?name=", taxon, sep="");
    } else {
      stop(paste(taxon, "is not a known taxon"));    
    }
  }
  
  if (is.null(type)) {
    type <- "&name_1=";
  } else {
    if (skipcheck == TRUE || sum(sapply(bioacoustica.listTypes(), match, type, nomatch=0)) == 1) {
      type <- sub(" ", "+", type);
      type <- paste("&name_1=", type, sep="");
    } else {
      stop(paste(type, "is not a valid annotation type"));
    }
  }
  
  url <- paste("http://bio.acousti.ca/R/annotations", taxon, type, sep="");
  annotations <- bioacoustica.call(url);
  return (annotations);
}

bioacoustica.call <- function(url) {
  download <- getURL(url, useragent="bioacousticaR");
  content <- read.csv(text = download);
  return(content);
}
