bioacoustica.downloadDemoData <- function(demo) {
  bioacoustica.mkdir("data")
  setwd("./data")
  foreach(i=1:length(demo)) %do% bioacoustica.downloadDemoDatum(demo[i])
  setwd("./..")
}

bioacoustica.downloadDemoDatum <- function(datum, sep_dirs=TRUE) {
  if (sep_dirs==TRUE) {
    bioacoustica.mkdir(names(datum));
    setwd(paste0("./",names(datum)))
  }
  foreach(i=1:length(datum[[1]])) %do% bioacoustica.getAnnotationFile(as.numeric(datum[[1]][i]))
  if (sep_dirs==TRUE) {
    setwd("./..")
  }
}
