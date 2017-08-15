bioacoustica.getOrthopteraNamesNoSubgenus <- function(c) {
  ba_names <- unique(read.csv(text = DrupalR::drupalr.get("http://bio.acousti.ca/", "aao/orthoptera", c)))
  ba_subspecies <- unique(read.csv(text = DrupalR::drupalr.get("http://bio.acousti.ca/", "aao/orthoptera/subspecies", c)))
  ba_names <- rbind(ba_names, ba_subspecies)
  ba_names$SupertreeTaxon <- gsub(' ', '_', ba_names$SupertreeTaxon)
  return(ba_names)
}