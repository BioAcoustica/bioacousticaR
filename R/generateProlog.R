library(bioacoustica)
library(dplyr)

taxa <- bioacoustica.listTaxa();
traits <- bioacoustica.listTraits(c);

#Only cascading traits
traits <- traits[!is.na(traits$Cascade),]
traits <- traits[traits$Cascade==1,]

#Replace spaces with undescores for Prolog varibale names, and remove some characters
taxa$taxon <- gsub(' ', '_', taxa$taxon)
taxa$taxon <- gsub('\\(', '_', taxa$taxon)
taxa$taxon <- gsub('\\)', '_', taxa$taxon)
taxa$taxon <- gsub('"', '', taxa$taxon)
taxa$taxon <- gsub('“', '', taxa$taxon)
taxa$taxon <- gsub('”', '', taxa$taxon)
taxa$taxon <- gsub('\\.', '', taxa$taxon)
taxa$taxon <- gsub("'", '', taxa$taxon)
taxa$taxon <- gsub("×", 'x', taxa$taxon)
taxa$taxon <- gsub('\\?', 'question_', taxa$taxon)
taxa$parent_taxon <- gsub(' ', '_', taxa$parent_taxon)
taxa$parent_taxon <- gsub('\\(', '_', taxa$parent_taxon)
taxa$parent_taxon <- gsub('\\)', '_', taxa$parent_taxon)
taxa$parent_taxon <- gsub('"', '', taxa$parent_taxon)
taxa$parent_taxon <- gsub('“', '', taxa$parent_taxon)
taxa$parent_taxon <- gsub('”', '', taxa$parent_taxon)
taxa$parent_taxon <- gsub('\\.', '', taxa$parent_taxon)
taxa$parent_taxon <- gsub("'", '', taxa$parent_taxon)
taxa$parent_taxon <- gsub("×", 'x', taxa$parent_taxon)
taxa$parent_taxon <- gsub('\\?', 'question_', taxa$parent_taxon)
taxa <-mutate_each(taxa, funs(tolower))
traits$Taxonomic.name <- gsub(' ', '_', traits$Taxonomic.name)
traits$Taxonomic.name <- gsub('\\(', '_', traits$Taxonomic.name)
traits$Taxonomic.name <- gsub('\\)', '', traits$Taxonomic.name)
traits$Taxonomic.name <- gsub('“', '', traits$Taxonomic.name)
traits$Taxonomic.name <- gsub('“', '', traits$Taxonomic.name)
traits$Taxonomic.name <- gsub('”', '', traits$Taxonomic.name)
traits$Taxonomic.name <- gsub('\\.', '', traits$Taxonomic.name)
traits$Taxonomic.name <- gsub("'", '', traits$Taxonomic.name)
traits$Taxonomic.name <- gsub("×", 'x', traits$Taxonomic.name)
traits$Taxonomic.name <- gsub('\\?', 'question_', traits$Taxonomic.name)
traits$Trait <- gsub(' ', '_', traits$Trait)
traits$Value <- gsub(' ', '_', traits$Value)
traits <-mutate_each(traits, funs(tolower))



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

mapply(writePrologTaxon,"orth.pl", taxa$taxon, taxa$parent_taxon)

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

write(app,"orth.pl", append=TRUE)