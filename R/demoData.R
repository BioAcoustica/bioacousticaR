bioacoustica.britishOrthoptera <- list(
  meconema.thalassinum = list(
    197,
    200
  ),
  tettigonia.viridissima = list(
    202
  ),
  decticus.verrucivorus = list(
    204,
    205
  ),
  pholidoptera.griseoaptera = list(
    207,
    209
  ),
  platycleis.albopunctata = list(
    211
  )
);

bioacoustica.downloadDemoData <- function(demo) {
  bioacoustica.mkdir("data")
  setwd("./data")
  foreach(i=1:length(demo)) %do% bioacoustica.downloadDemoDatum(demo[i])
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
  setwd("./..")
}
