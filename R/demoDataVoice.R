bioacoustica.voiceData <- function() {
  d <- t(as.data.frame.list(bioacoustica.voiceDataData))
  colnames(d) <- bioacoustica.voiceDataColumns
  return(d)
}

bioacoustica.voiceDataColumns <- c("section", "annotation_id", "text")

bioacoustica.voiceDataData <- list(
    c(
      "price",
      235, 
      "16th December. Recording number 4."
    ),
    c(
      "price",
      80,
      "8th December. Trafalgar."
    ),
    c(
      "price",
      236,
      "6th December.Recording number 1."
    ),
    c(
      "price",
      237,
      "20th December. Recording number 2. Queenstown. Platypleura brunea."
    ),
    c(
      "price",
      238,
      "Leisure Bay. Recording number 1."
    ),
    c(
      "price",
      109,
      "14th December. Recording number 3 on the way to Kruger." 
    ),
    c(
      "price",
      101,
      "11th December. On the way to Cozy Bay."
    ),
    c(
      "price",
      95,
      "15th December."
    ),
    c(
      "price",
      89,
      ""
    ),
    c(
      "price",
      72,
      "14th December. On the way to Kruger. Recording number 2."
    ),
    c(
      "bmnh",
      210,
      ""
    ),
    c(
      "bmnh",
      208,
      ""
    ),
    c(
      "bmnh",
      206,
      ""
    ),
    c(
      "bmnh",
      196,
      ""
    ),
    c(
      "bmnh",
      130,
      ""
     ),
    c(
      "bmnh",
      128,
      ""
     ),
    c(
      "bmnh",
      117,
      ""
     ),
    c(
      "bmnh",
      52,
      ""
     ),
    c(
      "bmnh",
      61,
      ""
     ),
    c(
      "bmnh",
      41,
      ""
     ),
    c(
      "bmnh",
      26,
      ""
  )
);
