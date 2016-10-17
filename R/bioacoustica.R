bioacoustica.getHandle <- function() {
  return (list(url = "http://bio.acousti.ca"));
}

bioacoustica.authenticate <- function(username, password) {
  return(drupalr.authenticate(bioacoustica.getHandle(), username, password));  
}

bioacoustica.call <- function(path) {
  message(paste0(bioacoustica.getHandle(), path));
  download <- drupalr.get(bioacoustica.getHandle(), path);
  return (read.csv(text = download));
}

bioacoustica.listTypes <- function() {
  path <- "/R/types";
  types <- bioacoustica.call(path);
  return (types);
}

bioacoustica.listTaxa <- function() {
  path <- "/R/taxa";
  taxa <- bioacoustica.call(path);
  return (taxa);
}

bioacoustica.listCollections <- function() {
  path <- "/R/collections";
  collections <- bioacoustica.call(path);
  return (collections);
}

bioacoustica.getAnnotations <- function(taxon=NULL, type=NULL, skipcheck=FALSE) {
  path <- "/R/annotations";
  annotations <- bioacoustica.call(path);
  return (annotations);
}

bioacoustica.listRecordings <- function(taxon=NULL, children=FALSE) {
  if (is.null(taxon)) {
    taxon <- "";
  } else {
    taxon <- sub(" ", "+", taxon)
  }
  if(!children) {
    path <- paste0("/R/recordings/", taxon);
  } else {
    path <- paste0("/R/recordings-depth/", taxon);
  }
  return (bioacoustica.call(path));
}


bioacoustica.getAnnotationFile <- function(annotation_id, c) {
  a <- bioacoustica.getAnnotations(c);
  file <- as.character(subset(a, 
                              id==annotation_id,
                              select="file")[1,1]);
  parts <- strsplit(file, "/");
  filename <- parts[[1]][7];
  #TODO: CHange to CURL
  download.file(file, destfile=filename);
  long <- readWave(filename);
  f <- long@samp.rate;
  wave <- cutw(long, f=f, from=subset(a, id==annotation_id,
                          select="start")[1,1], 
                          to=subset(a, id==annotation_id,select="end")[1,1],
                          method="Wave");
  file.remove(filename);
  nf <- paste0(filename,".",annotation_id,".wav");
  savewav(wave, f=f, file=nf);
  return(nf)
}

bioacoustica.getWaveFile <- function(url, start=NULL, end = NULL) {
  
}

bioacoustica.postComment <- function(path, body, c) {
  extra_pars = list(
    'field_type[und]' = '_none',
    'field_taxonomic_name[und]' = '',
    'field_start_time[und][0][value]' = '',
    'field_end_time[und][0][value]' = ''
  );
  drupalr.postComment(bioacoustica.getHandle(), path, body, extra_pars, c)
}

bioacoustica.postAnnotation <- function(path, type, taxon, start, end, c) {
  type_id <- as.character(subset(bioacoustica.listTypes(), Type==type, select=Term.ID)[1,])
  extra_pars = list(
    'field_type[und]' = type_id,
    'field_taxonomic_name[und]' = taxon,
    'field_start_time[und][0][value]' = start,
    'field_end_time[und][0][value]' = end
  );
  drupalr.postComment(bioacoustica.getHandle(), path, '', extra_pars, c);
}

bioacoustica.postFile <- function(upfile, c) {
  pars = list(
    'files[upload]' = fileUpload(filename=upfile)
  );
  drupalr.postForm(bioacoustica.getHandle(), "/file/add", "file_entity_add_upload", pars, c);
}


bioacoustica.mkdir <- function(name) {
  if (file.exists(name)){
    message(paste0("directory could not be created: ",name))
  } else {
    dir.create(file.path(name))
  }
}
