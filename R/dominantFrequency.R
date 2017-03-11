dominantFrequency <- function(filename) {
  filename <- paste0(filename,".wav")
  song <- readWave(paste0("bioacoustica_data/",filename))
  f <- song@samp.rate
  data <- meanspec(song, f=f, plot=FALSE)
  
  return(data[[which.max(data[,2]),1]])
}