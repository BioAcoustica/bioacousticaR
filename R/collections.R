bioacoustica.collectionMetadata <- function(collectionID, c) {
  collection <- read.csv(text=DrupalR::drupalr.get("bio.acousti.ca/", paste0("collection/csv/",collectionID,"/", collectionID), c))
  return(collection)
}

bioacoustica.collectionDownload <- function(collectionID, c) {
  collection <- NULL;
  if (typeof(collectionID) != "list") {
    collection <- read.csv(text=DrupalR::drupalr.get("bio.acousti.ca/", paste0("collection/csv/",collectionID,"/", collectionID), c))
  } else {
    collection <- collectionID
  }
  bioacoustica.mkdir("bioacoustica_data")
  
  downloadData <- function(data, name) {
    url <- data["recording_url"]
    filename <- paste0(data["entity_id"],".wav")
    download.file(url, filename)
    
    if (data["entity_type"] == "annotation") {
      trimFile(filename, data["start"], data["end"])
    }
  }
  
  trimFile <- function(filename, start, end) {
    long <- readWave(filename)
    f <- long@samp.rate
    short <- seewave::cutw(long, f=f, from=as.numeric(start),to=as.numeric(end), method="Wave")
    file.remove(filename)
    seewave::savewav(short, f=f, file=filename)
  }
  
  urls <- as.character(collection[,"recording_url"])
  filenames <- as.character(collection[,"entity_id"])
  setwd("./bioacoustica_data")
  apply(collection, 1, downloadData)
  setwd("..")
  
}

bioacoustica.collectionAnalyse <- function(FUN, collection) {
  functions <- FUN
  n <- names(collection)
  i <- 1
  foreach (i=1:length(functions)) %do% {
    FUN <- match.fun(functions[i])
    column <- sapply(collection[,"entity_id"], FUN)
    collection <- cbind(collection, column)
  }
  names(collection) <- c(n, functions)
  return(collection)
}
