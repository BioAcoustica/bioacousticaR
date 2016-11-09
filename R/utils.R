# Utility function to fetch a view from bioacoustica
# we just use fread ability to download data directly from http
#
fetchView <- function(path, 
                      root_url="http://bio.acousti.ca", 
                      verbose=F){
  csv_path <- file.path(root_url, path)
  if(verbose)
    message(paste0("Getting", csv_path))
  fread(csv_path)
}

# Downloads a partial binary file (see `curl -r`)
# 
# Utility to save server and client resource by downloading only 
# segment of files.
# 
# @param connection the url to a binary object
# @param start_byte the first byte to download
# @param end_byte the last byte to download
# @param n_retry how many times to retry when download fails
downloadBinRange <- function(connection, start_byte, end_byte, 
                             n_retry = 5){
  # this way we can fecth only a part of a binary file
  for(i in 1:n_retry){
    opts <- curlOptions(range = paste(start_byte, end_byte,sep="-"))
    raw <- getBinaryURL(connection, .opts = opts)
    expected_length <- end_byte - start_byte + 1
    
    if(expected_length == length(raw))
      return(raw)
    warning(paste("Failed to retreive", connection, ". Retrying..."))
  }
  stop(paste("Did not manage to fetch", connection, "!"))
}

# use a modified version of the actual tuneR::readWave function 
# to get the position of the first data point
findDataChunkByte <-
  function(filename, header = FALSE){
    if(!is.character(filename))
      stop("'filename' must be of type character.")
    if(length(filename) != 1)
      stop("Please specify exactly one 'filename'.")
    if(!file.exists(filename))
      stop("File '", filename, "' does not exist.")
    if(file.access(filename, 4))
      stop("No read permission for file ", filename)
    
    ## Open connection
    con <- file(filename, "rb")
    on.exit(close(con)) # be careful ...
    int <- integer()
    
    ## Reading in the header:
    RIFF <- readChar(con, 4)
    file.length <- readBin(con, int, n = 1, size = 4, endian = "little")
    WAVE <- readChar(con, 4)
    
    ## waiting for the WAVE part
    i <- 0
    while(!(RIFF == "RIFF" && WAVE == "WAVE")){
      i <- i+1
      seek(con, where = file.length - 4, origin = "current")
      RIFF <- readChar(con, 4)
      file.length <- readBin(con, int, n = 1, size = 4, endian = "little")
      WAVE <- readChar(con, 4)
      if(i > 5) stop("This seems not to be a valid RIFF file of type WAVE.")
    }
    
    FMT <- readChar(con, 4)    
    bext <- NULL
    ## extract possible bext information, if header = TRUE
    if (header && (tolower(FMT) == "bext")){
      bext.length <- readBin(con, int, n = 1, size = 4, endian = "little")
      bext <- sapply(seq(bext.length), function(x) readChar(con, 1, useBytes=TRUE))
      bext[bext==""] <- " "
      bext <- paste(bext, collapse="")
      FMT <- readChar(con, 4)
    }
    
    ## waiting for the fmt chunk
    i <- 0
    while(FMT != "fmt "){
      i <- i+1
      belength <- readBin(con, int, n = 1, size = 4, endian = "little")
      seek(con, where = belength, origin = "current")
      FMT <- readChar(con, 4)
      if(i > 5) stop("There seems to be no 'fmt ' chunk in this Wave (?) file.")
    }
    fmt.length <- readBin(con, int, n = 1, size = 4, endian = "little")
    pcm <- readBin(con, int, n = 1, size = 2, endian = "little", signed = FALSE)
    ## FormatTag: only WAVE_FORMAT_PCM (0,1), WAVE_FORMAT_IEEE_FLOAT (3), WAVE_FORMAT_EXTENSIBLE (65534, determined by SubFormat)
    if(!(pcm %in% c(0, 1, 3, 65534)))
      stop("Only uncompressed PCM and IEEE_FLOAT Wave formats supported")
    channels <- readBin(con, int, n = 1, size = 2, endian = "little")
    sample.rate <- readBin(con, int, n = 1, size = 4, endian = "little")
    bytes.second <- readBin(con, int, n = 1, size = 4, endian = "little")
    block.align <- readBin(con, int, n = 1, size = 2, endian = "little")
    bits <- readBin(con, int, n = 1, size = 2, endian = "little")
    if(!(bits %in% c(8, 16, 24, 32, 64)))
      stop("Only 8-, 16-, 24-, 32- or 64-bit Wave formats supported")
    ## non-PCM (chunk size 18 or 40)
    
    if(fmt.length >= 18){    
      cbSize <- readBin(con, int, n = 1, size = 2, endian = "little")
      ## chunk size 40 (extension 22)
      if(cbSize == 22 && fmt.length == 40){
        validBits <- readBin(con, int, n = 1, size = 2, endian = "little")
        dwChannelMask <- readBin(con, int, n = 1, size = 4, endian = "little")    
        channelNames <- MCnames[as.logical(intToBits(dwChannelMask)),"name"]
        SubFormat <- readBin(con, int, n = 1, size = 2, endian = "little", signed = FALSE)
        x <- readBin(con, "raw", n=14)
      } else {
        if(cbSize > 0) 
          seek(con, where = fmt.length-18, origin = "current")
      }   
    }    
    if(exists("SubFormat") && !(SubFormat %in% c(0, 1, 3)))
      stop("Only uncompressed PCM and IEEE_FLOAT Wave formats supported")
    
    ## fact chunk
    #    if((pcm %in% c(0, 3)) || (pcm = 65534 && SubFormat %in% c(0, 3))) {
    #      fact <- readChar(con, 4)
    #      fact.length <- readBin(con, int, n = 1, size = 4, endian = "little")
    #      dwSampleLength <- readBin(con, int, n = 1, size = 4, endian = "little")
    #    }
    
    DATA <- readChar(con, 4)
    ## waiting for the data chunk    
    i <- 0    
    
    while(length(DATA) && DATA != "data"){
      i <- i+1
      belength <- readBin(con, int, n = 1, size = 4, endian = "little")
      o = seek(con, where = belength, origin = "current")
      DATA <- readChar(con, 4)
      if(i > 5) stop("There seems to be no 'data' chunk in this Wave (?) file.")
    }
    # seek where=NA returns current offset
    return(seek(con, where=NA)+4)
  }