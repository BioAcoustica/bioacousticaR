library(bioacoustica)
library(testthat)
library(tuneR)

# utility to make a synthetic (unifor distributed) wave and save it
makeNoiseWaveFile <- function(f=44100, bits=16, duration=5, extensible=F){
  series  <- round(runif(f*duration, min=-1,max=+1), 3)
  wave = tuneR::Wave(left=series, samp.rate=f, bit=1)
  wave = tuneR::normalize(wave,as.character(bits),
                          center=F, rescale=F)
  out = tempfile("ba_test",fileext = ".wav")
  tuneR::writeWave(wave, out, extensible=extensible)
  list(file = out, x = series)
}

test_that("We can make a fake wave file and retreive its value (vs original values)", {
  #generate 3second of pseudorandom data
  set.seed(12324)
  o = makeNoiseWaveFile()
  wave_from_file = tuneR::readWave(o$file)
  unlink(o$file)
  #the time sewries, from file
  new_x = tuneR::normalize(wave_from_file, 
                   "1",  center=F, rescale=F)@left
  testthat::expect_length(new_x, length(o$x))
  # two object should be the same +- epsion (float -> 16b int -> float)
  testthat::expect_lt(sum(abs(new_x - o$x)) / (44100 * 5), 1e-4)
  
})


test_that("We can use our partial dowload on local file and retreive its value", {
  #generate 3second of pseudorandom data
  set.seed(12324)
  # chunk start and end
  start = 1
  end=2
  
  o = makeNoiseWaveFile()
  dst = tempfile("ba_test",fileext = ".wav")
  getAnnotationFile(paste0("file://",o$file), 
                    start, end,dst=dst)
  
  wave_from_file = tuneR::readWave(dst)
  unlink(dst)
  unlink(o$file)
  
  new_x <- tuneR::normalize(wave_from_file, 
                           "1",  center=F, rescale=F)@left
  x <- o$x[(start*44100 + 1) : (end * 44100 +1)]
  testthat::expect_length(new_x, length(x))

  # two object should be the same +- epsion (float -> 16b int -> float)
  testthat::expect_lt(sum(abs(new_x - x)) / (44100 * 1), 1e-4)
  
})

