bioacoustica.downloadDemoData <- function(demo) {
  bioacoustica::bioacoustica.mkdir("data")
  setwd("./data")
  i <- 1
  foreach(i=1:length(demo)) %do% bioacoustica::bioacoustica.downloadDemoDatum(demo[i])
  setwd("./..")
}

bioacoustica.downloadDemoDatum <- function(datum, sep_dirs=TRUE) {
  if (sep_dirs==TRUE) {
    bioacoustica::bioacoustica.mkdir(names(datum));
    setwd(paste0("./",names(datum)))
  }
  i <- 1
  foreach(i=1:length(datum[[1]])) %do% bioacoustica::bioacoustica.getAnnotationFile(as.numeric(datum[[1]][i]))
  if (sep_dirs==TRUE) {
    setwd("./..")
  }
}
