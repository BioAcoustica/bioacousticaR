#' Dowload a list of all annotations 
#' 
#' Download the information corresponding 
#' to all available annotaions on bioacoustica
#' 
#' @param path the view containing the annotations
#' @return a \code{data.table}. The column \code{id} refers to the 
#' unique identifier of an annotation. \code{start} and \code{end} identify the
#' section of this annotation and \code{file} maps the URL of the raw audio file.
#' Other annotation data are available as extra columns.
#' @export
getAllAnnotationData <- function(path = "/R/annotations") {
  out <- fetchView(path)
  out[, id :=as.integer(id)]
  out[, end :=as.numeric(end)]
  out[, start :=as.numeric(start)]
  out[, date :=as.POSIXct(date)]
  #todo warn when na were omited
  setkey(out, id)
  na.omit(out)
  
}


#' Fetch a portion of a remote wav file
#' 
#' This function can download only a portion of a wave file
#' stored online and store it locally as a new wave file.
#' It proceeds by dowloading metadata, uses them to locate the file chunk
#' and reconstitute a file
#' 
#' @param file the URL of a file
#' @param start the start of the desired section, in second
#' @param end the end of the desired section, in second
#' @param dst a character vector indicating where to save the resulting file
#' @param force whether to downoad and overwrite pre-existing file
#' @param header_size the number of bytes in the header of a wave file
#' @param verbose weher to print extra information
#' @return the path to resulting file
#' @seealso \code{\link{dowloadFilesForAnnotations}}, a wrapper around this function
#' @export
getAnnotationFile <- function(file, 
                              start, 
                              end, 
                              dst, 
                              force=F,
                              header_size=44, 
                              verbose=F){
  if(verbose)
    message(paste("getting", file, "from", start, "to", end))
  
  # the file is already there
  if(!force & file.exists(dst))
	  return(dst)
  
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
  end_sample = floor((end * f) / packet_size) * packet_size 
  
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
    wav <- readWave(tmp_file)
  )
  
  duration <- length(wav@left)/ wav@samp.rate
  if(abs((end - start) - duration) > 0.5)
    stop(sprintf("Error whilst reading wav, resulting wav
                 does not have expected duration.
                 Expected = %f. real = %f",end-start,duration ))
  
  # here we fix the wave metadata by rewriting it
  writeWave(wav, dst)
  return(dst)
}


#' Retreive list of annotation files from a query
#'
#' This function uses a formated query
#' (i.e. table) to retreive annotation raw data
#' 
#' @param query a data.table or data.frame (see details)
#' @param dst_dir a directory to store the resulting data
#' @param prefix a string to prepend to filenames
#' @param force whether to downoad and overwrite pre-existing file
#' @param ... extra argument passed to \code{link{getAnnotationFile}}
#' @return an inflated query with a extra columns mapping the path of the saved audio files
#' @details \code{query} must contain the columns \code{id},
#' \code{start}, \code{end}, \code{file}. They indicate, the annotation uid
#' , the start and end of the wav file, and the url of the wav file, respactively.
#' Typically, it will be obtained through \code{\link{getAllAnnotationData}}.
#' @seealso \code{\link{getAllAnnotationData}}
#' @examples
#' \dontrun{
#' # we retreive all annotations from the database
#' all_annotations = getAllAnnotationData()
#' # we filter for only those made by one author before a certain date
#' query = all_annotations[author=="qgeissmann" & date < "2016-10-26"]
#' # we make one file for each annotation and save it in dst_dir
#' my_annotations <- dowloadFilesForAnnotations(query,
#'                                dst_dir = "/tmp/my_annotation",
#'                                verbose=T)
#' }
#' @export
dowloadFilesForAnnotations <- function(query, 
                                       dst_dir, 
                                       prefix="annotation",
                                       force=F,
                                       ...){
  if(!dir.exists(dst_dir))
    stop(paste(dst_dir, "does not exist"))
  q <- as.data.table(query)
  q[, dst := paste(dst_dir, paste(prefix,id,basename(file),sep = "_"), sep="/")]
  q[, start := as.numeric(start)]
  q[, end := as.numeric(end)]
  annotation_file_map <- q[, 
                           .(annotation_path = getAnnotationFile(file, start, end, 
																 dst=dst, force=force, ...)), 
                           by=id]
  q[, dst := NULL]
  setkeyv(q, "id")
  setkeyv(annotation_file_map, "id")
  q[annotation_file_map]
}
