frequencySpectrum <- function(filename, min_cutoff=1) {
  filename <- paste0(filename,".wav")
  song <- readWave(paste0("bioacoustica_data/",filename))
  f <- song@samp.rate
  data <- meanspec(song, f=f, plot=FALSE)
  data <- data[which(data[,1] > min_cutoff),]
  data <- data[which(data[,2] > mean(data[,2])+sd(data[,2])),]
  return(paste0(min(data[,1]),"-",max(data[,1])))
}