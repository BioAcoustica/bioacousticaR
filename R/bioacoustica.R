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
  if (is.null(taxon)) {
    taxon <- "?name=";
  } else {
    if (skipcheck == TRUE || sum(sapply(bioacoustica.listTaxa(), match, taxon, nomatch=0)) == 1) {
      taxon <- sub(" ", "+", taxon);
      taxon <- paste0("?name=", taxon);
    } else {
      stop(paste(taxon, "is not a known taxon"));    
    }
  }
  
  if (is.null(type)) {
    type <- "&name_1=";
  } else {
    if (skipcheck == TRUE || sum(sapply(bioacoustica.listTypes(), match, type, nomatch=0)) == 1) {
      type <- sub(" ", "+", type);
      type <- paste0("&name_1=", type);
    } else {
      stop(paste(type, "is not a valid annotation type"));
    }
  }
  
  path <- paste0("R/annotations", taxon, type);
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

bioacoustica.getAnnotationFiles <- function(df) {
  vector <- vector(mode="list", 1);
  data <- df[,c("start", "end", "file")];
  apply(data, 1, function(row) {
    parts <- strsplit(as.character(row[["file"]]), "/");
    filename <- parts[[1]][[7]];
    download.file(row[["file"]], destfile=filename);
    long <- readWave(filename);
    f <- long@samp.rate;
    wave <- cutw(long, f=f, from=as.numeric(row[["start"]]), to=as.numeric(row[["end"]]), method="Wave");
    print(typeof(wave));
    vector[[1]] <- wav;
  });
  return(vector);
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
  drupalr.postForm(bioacoustica.getHandle(), "/file/add", "file_entity_add_upload, pars, c)
}
