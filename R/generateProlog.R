prologSafe <- function(check) {
  check <- gsub(' ', '_', check)
  check <- gsub('\\(', '_', check)
  check <- gsub('\\)', '_', check)
  check <- gsub('"', '', check)
  check <- gsub('“', '', check)
  check <- gsub('”', '', check)
  check <- gsub('\\.', '', check)
  check <- gsub("'", '', check)
  check <- gsub("×", 'x', check)
  check <- gsub('\\?', 'question_', check)
  check <- gsub('-', '_', check)
  check <-mutate_each(check, funs(tolower))
  return(check)
}

writePrologTaxon <- function(file, term, parent) {
  if (parent == '') {
    parent <- "animal"
  }
  
  prolog <- paste0(term,"(a_kind_of, ",parent,").")
  write(prolog, file, append =TRUE)
  
  taxontraits <- traits[traits$Taxonomic.name==term,]
  trait_count <- nrow(taxontraits)
  if (trait_count > 0 ) {
    for(i in 1:trait_count) {
      prolog <- paste0(term,"(",as.character(taxontraits[i,"Trait"]),", ",as.character(taxontraits[i,"Value"]),").")
      write(prolog, file, append =TRUE)
    }
  }
}

generateProlog <- function(file) {
  taxa <- bioacoustica.listTaxa();
  traits <- bioacoustica.listTraits(c);
  
  #Only cascading traits
  traits <- traits[!is.na(traits$Cascade),]
  traits <- traits[traits$Cascade==1,]
  
  #Replace spaces with undescores for Prolog varibale names, and remove some characters
  taxa$taxon <- prologSafe(taxa$taxon)
  taxa$parent_taxon <- prologSafe(taxa$parent_taxon)
  traits$Taxonomic.name <- prologSafe(traits$Taxonomic.name)
  traits$Trait <- prologSafe(traits$Trait)
  
  mapply(writePrologTaxon, file, taxa$taxon, taxa$parent_taxon)
  
  app <- "value(Frame, Slot, Value) :-
  Query=..[Frame, Slot, Value],
  call(Query), !.
  
  value(Frame, Slot, Value) :-
  parent(Frame, ParentFrame),
  value(ParentFrame, Slot, Value).
  
  parent(Frame, ParentFrame) :-
  ( Query=..[Frame, a_kind_of, ParentFrame];
  Query=..[Frame, an_instance_of, ParentFrame]),
  call(Query).
  
  :- initialization go.
  
  go :- 
  current_prolog_flag(argv,Argv),
  
  opt_parse([[opt(taxon), 
  type(atom),
  shortflags([n]), 
  longflags([taxon])]
  ,[opt(trait),
  type(atom),
  shortflags([t]),
  longflags([trait])]
  ],
  Argv,
  Opts,
  _),
  dict_options(DicOp, Opts),
  
  
  (value(DicOp.taxon, DicOp.trait, X), 
  writeln(X),
  halt
  )."

  write(app,file, append=TRUE)
}

generateProlog("orth.pl")
