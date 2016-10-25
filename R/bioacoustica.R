rm(list=ls())
library(RCurl)
library(data.table)
library(DrupalR)

#' @param url the root url for bioacoustica
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

# bioacoustica.listTypes <- function() {
#   path <- "/R/types";
#   types <- bioacoustica.call(path);
#   return (types);
# }
# 
# bioacoustica.listTaxa <- function() {
#   path <- "/R/taxa";
#   taxa <- bioacoustica.call(path);
#   return (taxa);
# }
# 
# bioacoustica.listCollections <- function() {
#   path <- "/R/collections";
#   collections <- bioacoustica.call(path);
#   return (collections);
# }

getAllAnnotationData <- function(path = "/R/annotations") {
  fetchView(path);
}

downloadBinRange <- function(connection, start_byte, end_byte){
  # this way we can fecth only a part of a binary file
  opts = curlOptions(range = paste(start_byte, end_byte,sep="-"))
  raw <- getBinaryURL(connection, .opts = opts)
}

getAnnotationFile <- function(file, start, end, dst, header_size=44){
  print (file)
  header_bin = downloadBinRange(file, 0, header_size)
  header_tmp_file <- tempfile("ba_header_", fileext = ".wav")
  writeBin(header_bin, header_tmp_file)
  headers <- readWave(header_tmp_file)
  unlink(header_tmp_file)
  
  # we have the metadata in "header"
  f = headers@samp.rate
  bits = headers@bit
  stereo = headers@stereo
  pcm = headers@pcm
  
  if(!pcm){
    stop("Only PCM supported!")
  }
  
  # number of byte per sample
  packet_size = (stereo + 1) * bits/8
  # we ensure that our sample are multiple of the packet size
  start_sample = floor((start * f) / packet_size) * packet_size 
  end_sample = floor(((end +1) * f) / packet_size) * packet_size 
  
  # we use metadata to comput first and last bytes needed
  start_byte = 1 + header_size + packet_size * start_sample 
  end_byte = 1 + header_size + packet_size * end_sample
  
  # we download the corresponding sound
  sound_bin <- downloadBinRange(file, start_byte, end_byte)
  # then we prepend metadata
  recomposed_wav <- c(header_bin, sound_bin)
  #writeBin(recomposed_wav,"/tmp/testok.wav")
  
  tmp_file <- tempfile("ba_", fileext = ".wav")
  writeBin(recomposed_wav,tmp_file)
  
  # check we can read the wave file
  suppressWarnings(
    wav <- readWave(tmp_file, unit="seconds")
  )
  
  duration <- length(wav@left)/ wav@samp.rate
  if(abs((end - start) - duration) > 0.5)
    stop(sprintf("Error whilst reading wav, resulting wav
           does not have expected duration.
            Expected = %f. real = %f",end-start,duration ))
  # here we fix the wave metadata
  writeWave(wav, dst)
  return(dst)
}

#yo <- "/tmp/test/annotation_246_564_4_Chorthippus_brunneus_766r1.wav"
#

query = getAllAnnotationData()

q <- query[author == "qgeissmann"]

q[, dst := paste("/tmp/test", paste("annotation",id,basename(file),sep = "_"), sep="/")]
q[, start := as.numeric(start)]
q[, end := as.numeric(end)]

qq <- q[, getAnnotationFile(file, start, end, dst=dst), by=id]



# 
# bioacoustica.postComment <- function(path, body, c) {
#   extra_pars = list(
#     'field_type[und]' = '_none',
#     'field_taxonomic_name[und]' = '',
#     'field_start_time[und][0][value]' = '',
#     'field_end_time[und][0][value]' = ''
#   );
#   drupalr.postComment(bioacoustica.getHandle(), path, body, extra_pars, c)
# }
# 
# bioacoustica.postAnnotation <- function(path, type, taxon, start, end, c) {
#   type_id <- as.character(subset(bioacoustica.listTypes(), Type==type, select=Term.ID)[1,])
#   extra_pars = list(
#     'field_type[und]' = type_id,
#     'field_taxonomic_name[und]' = taxon,
#     'field_start_time[und][0][value]' = start,
#     'field_end_time[und][0][value]' = end
#   );
#   drupalr.postComment(bioacoustica.getHandle(), path, '', extra_pars, c);
# }
# 
# bioacoustica.postFile <- function(upfile, c) {
#   pars = list(
#     'files[upload]' = fileUpload(filename=upfile)
#   );
#   drupalr.postForm(bioacoustica.getHandle(), "/file/add", "file_entity_add_upload", pars, c);
# }
# 
# 
# bioacoustica.mkdir <- function(name) {
#   if (file.exists(name)){
#     message(paste0("directory could not be created: ",name))
#   } else {
#     dir.create(file.path(name))
#   }
# }
