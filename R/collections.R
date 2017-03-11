collectionDownload <- function(collectionID, c) {
  
  collection <- read.csv(text=drupalr.get("bio.acousti.ca/", paste0("collection/csv/",collectionID,"/", collectionID), c))
  
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
    short <- cutw(long, f=f, from=as.numeric(start),to=as.numeric(end), method="Wave")
    file.remove(filename)
    savewav(short, f=f, file=filename)
  }
  
  urls <- as.character(collection[,"recording_url"])
  filenames <- as.character(collection[,"entity_id"])
  setwd("./bioacoustica_data")
  apply(collection, 1, downloadData)
  setwd("..")
  
}