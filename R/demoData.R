bioacoustica.britishOrthoptera <- list(
  meconema.thalassinum = list(
    197,
    200
  ),
  tettigonia.viridissima = list(
    202
  )
);

bioacoustica.downloadDemoData <- function(demo) {
  foreach(i=1:length(demo)) %do% bioacoustica.downloadDemoDatum(demo[i])
}

bioacoustica.downloadDemoDatum <- function(datum) {
  bioacoustica.mkdir(names(datum));
  setwd(paste0("./",names(datum)))
  foreach(i=1:length(datum[[1]])) %do% bioacoustica.getAnnotationFile(as.numeric(datum[[1]][i]))
  message(datum[i])
  setwd("./..")
}
