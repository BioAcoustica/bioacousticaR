# http://samcarcagno.altervista.org/blog/basic-sound-processing-r/

bioacoustica.powerspectrum <- function(wave, plot=TRUE) {
  s1 <- wave@left
  
  n <- length(s1)
  p <- fft(s1)
  
  nUniquePts <- ceiling((n+1)/2)
  p <- p[1:nUniquePts] #select just the first half since the second half 
  # is a mirror image of the first
  p <- abs(p)  #take the absolute value, or the magnitude 
  
  p <- p / n #scale by the number of points so that
  # the magnitude does not depend on the length 
  # of the signal or on its sampling frequency  
  p <- p^2  # square it to get the power 
  
  # multiply by two (see technical document for details)
  # odd nfft excludes Nyquist point
  if (n %% 2 > 0){
    p[2:length(p)] <- p[2:length(p)]*2 # we've got odd number of points fft
  } else {
    p[2: (length(p) -1)] <- p[2: (length(p) -1)]*2 # we've got even number of points fft
  }
  
  freqArray <- (0:(nUniquePts-1)) * (wave@samp.rate / n) #  create the frequency array 
  
  if (plot==TRUE) {
    plot(freqArray/1000, 10*log10(p), type='l', col='black', xlab='Frequency (kHz)', ylab='Power (dB)')
  }
  
  return(cbind(freqArray, p))
  
}