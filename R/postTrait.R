bioacoustica.postTrait <- function(taxon_name, call_type=NULL, trait=NULL, value=NULL, temp=NULL, sex=NULL, cascade=0){
  pars=list(
    "group_audience[und][]"=2,
    "group_content_access[und]"=2,
    "field_taxonomic_name[und]"=taxon_name,
    "field_bioacoustic_traits[und][0][field_call_type][und][0][value]"=call_type,
    "field_bioacoustic_traits[und][0][field_trait][und]"=trait,
    "field_bioacoustic_traits[und][0][field_value][und][0][value]"=value,
    "field_bioacoustic_traits[und][0][field_temperature][und][0][value]"=temp,
    "field_bioacoustic_traits[und][0][field_sex_trait][und][0][value]"=sex
  )
  if (cascade==1) {
    pars <-c(pars, "field_bioacoustic_traits[und][0][field_cascade_down][und]"=1)
  }
  drupalr.postForm("bio.acousti.ca", "/node/add/bioacoustic-traits", "bioacoustic-traits-node-form", pars=pars, c)
}