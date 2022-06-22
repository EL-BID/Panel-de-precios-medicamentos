function(x){
  x<-as.data.frame(x)
  x$prod_desc<-gsub('\\(|\\)|\\/|\\;|\\+|\\-|\\:|\\*|\\_', " ", x$prod_desc)
  #x$prod_desc<-gsub("[[:punct:][:blank:]]+", " ", x$prod_desc)
  x$prod_desc<-iconv(x$prod_desc, to="ASCII//TRANSLIT")
  x$prod_desc<-trimws(x$prod_desc)
  x$prod_desc<-toupper(x$prod_desc)
  x$prod_desc<-str_squish(x$prod_desc)
  initial_matrix<-matrix(,nrow = nrow(x),ncol=1200)
  for (i in 1:nrow(x)) {
    t<-unique(str_split(x$prod_desc[i]," ",simplify = TRUE),MARGIN = 2)
    for (j in 1:ncol(t)) {
      initial_matrix[i,j]<-t[j]
    }
    
  }
  return(initial_matrix)
  
}



