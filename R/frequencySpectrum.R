dominantFrequency <- function(filename) {
  filename <- paste0(filename,".wav")
  song <- readWave(paste0("bioacoustica_data/",filename))
  f <- song@samp.rate
  data <- meanspec(song, f=f, plot=FALSE)
  data <- data[which(data[,2] > mean(ms[,2])),]
  return(c(min(data[,1]),"-",max(data[,1]))
}