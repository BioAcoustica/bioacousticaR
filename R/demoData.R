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
  ),
  metrioptera.brachyptera = list(
    213,
    218
  ),
  roeseliana.roeselii = list(
    220,
    222
  ),
  conocephalus.fuscus = list(
    224,
    225
  ),
  conocephalus.dorsalis = list(
    227
  ),
  gryllus.campestris = list(
    229
  ),
  nemobius.sylvestris = list(
    231
  ),
  gryllotalpa.gryllotalpa = list(
    232,
    46,
    233
);

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
