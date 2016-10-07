bioacoustica.getHandle <- function() {
  return (list(url = "http://bio.acousti.ca"));
}

bioacoustica.call <- function(path) {
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

bioacoustica.getRecordings <- function(taxon=NULL, children=FALSE, skipcheck=FALSE) {
  if (is.null(taxon)) {
    taxon <- "";
  } else {
    if (skipcheck == TRUE || sum(sapply(bioacoustica.listTaxa(), match, taxon, nomatch=0)) == 1) {
      taxon <- sub(" ", "+", taxon);
    } else {
      #TO DO: check it's in the list
      stop(paste(taxon, "is not a known taxon"));    
    }
  }
  if(!children) {
    path <- paste0("/R/recordings/", taxon);
    recordings <- bioacoustica.call(path);
  } else {
    #TODO:Get taxon ID
    tid <- 262;
    path <- paste0("/R/recordings/depth/", tid);
    recordings <- bioacoustica.call(path);
  }
  return (recordings);
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
