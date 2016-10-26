# pass
#
# ss
# 
# @param url the root url for bioacoustica
getHandle <- function(url="http://bio.acousti.ca"){
  return(list(url))
}

authenticate <- function(username, password) {
  return(drupalr.authenticate(getHandle(), username, password));  
}

fetchView <- function(path, verbose=F) {
  if(verbose)
    message(paste0(getHandle(), path));
  download_str <- drupalr.get(getHandle(), path);
  return (fread(download_str));
}

# To download a partial binary file (see `curl -r`)
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

