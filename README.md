bioacousticaR
===================

An `R` package interfacing [BioAcoustica](http://bio.acousti.ca).

BioAcoustica is a sound repository and analysis platform for recordings of wildlife sound.
This package provides a toolbox to search and retrieve recordings in order to build a local collection for subsequent analysis.
In addition, it allows to upload annotated audio files in bash.



Building a local collection
----------------------------

Bioacoustica allows users to tag segment of recordings.
This generates so called **"annotations"**.
Each annotation has a parent audio file, a start and an end time, and other informations (taxon, author,...).

An analysis project will generally involve fetching files corresponding to annotations in order to process them locally.

In `R`, we will start by listing available annotations:

```R
library(bioacoustica)
all_annotations <- getAllAnnotationData()
```

Now, we have a `data.table` (a `data.table` is essentially a `data.frame` with extra functionalities) containing a list of annotation (one per row).
We then can *select* a subset of annotation. For instance, all annotations made by "qgeissmann", after "2016-10-22":

```R
target_annotations <- all_annotations[author == "qgeissmann" & date > "2016-10-22"]
```

Now we can actually download one audio segments for each annotation.
We just need to define where to save these files (the `DATA_DIR` variable in this example).

```R
DATA_DIR <- "/tmp/audio_data"
target_annotations <- dowloadFilesForAnnotations(target_annotations,
                                dst_dir = DATA_DIR,
                                verbose=T)
```                         

Now, `target_annotations` has been updated with a new column (`annotation_path`) that refers to the path of the saved file.
By default, file will not be re-downloaded if they already exist.



As a simple example, we could open each file and retrieve its duration:

```R
getDuration <- function(file){
  wav <- tuneR::readWave(file)
  length(wav@left) / wav@samp.rate
}
# we use the magic of data.table `by`:
durations  <- target_annotations[ ,
                                  .(duration = getDuration(annotation_path)),
                                  by=id]
print(durations)
```

This way, we have one annotation per id.

The same approach can be used to make much more complicated analysis. on instance, you could replace `getDuration()` by a function that computes a power spectrum.


Uploading data and pushing annotations
--------------------------------------------

TODO

 



