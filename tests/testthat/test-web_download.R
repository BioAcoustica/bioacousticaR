library(data.table)
library(bioacoustica)
library(testthat)

TEST_FILE <- "http://bio.acousti.ca/sites/bio.acousti.ca/files/600_7_Gryllotalpa_gryllotalpa_17.wav"
is.POSIXt <- function(x) inherits(x, "POSIXt")
ANNOTATION_FIELD_TEST_LIST <- list(
  id = "is.integer",
  start = "is.numeric",
  end = "is.numeric",           
  file = "is.character",
  recording = "is.character",
  original_tape = "is.character",
  author = "is.character",
  date = "is.POSIXt"
)

test_that("We can download the list of annotations, 
          and that the results has the fields we want", {
            annotations <- getAllAnnotationData()
            
            # We should have all the expected fields  
            testthat::expect_true(
              all(names(ANNOTATION_FIELD_TEST_LIST) %in% colnames(annotations))
            )
            
            lapply(names(ANNOTATION_FIELD_TEST_LIST), function(n){
              testFun <- ANNOTATION_FIELD_TEST_LIST[[n]]
              test_res <- get(testFun)(annotations[[n]])
              testthat::expect_true(test_res, 
                                    info=sprintf("Variable `%s` failed test `%s`", n, testFun))
            }
            )
          })


test_that("Annotation are formated properly", {
  annotations <- getAllAnnotationData()
  # id should be the unique key
  testthat::expect_true(key(annotations)=="id")
  
  # no duplication of id
  testthat::expect_false(any(duplicated(annotations)))
  
  # select rows where start is greater than end. should have 0
  testthat::expect_equal(nrow(annotations[start >end]), 0)
  
})





test_that("We can download section of an arbitrary file", {
  dst = tempfile("ba_test_", fileext = ".wav")
  getAnnotationFile(TEST_FILE, start = 1, end=2, dst=dst)
  wav = tuneR::readWave(dst)
  unlink(dst)
  # we should have almost extacly 1s of data (+- 1sample)
  testthat::expect_lt(abs(1 - length(wav@left)/wav@samp.rate), 1e-4)
  
  
  #todo this should fail!
  #getAnnotationFile(TEST_FILE, start = 10000, end=10010, dst=dst)
})
