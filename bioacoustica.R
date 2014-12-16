library(RCurl);

bioacoustica.getAnnotations <- function(species=NULL) {
  download <- getURL("http://bio.acousti.ca/R/annotations?field_taxonomic_name=Heteropteryx dilatata");
  annotations <- read.csv(text = download);
  return (annotations);
}
