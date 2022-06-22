removeWords <- function(str, stopwords) {
  
  stopwords$stopword<-iconv(stopwords$stopword, to="ASCII//TRANSLIT")
  lista_palavras<-matrix(,nrow = nrow(str),ncol = ncol(str))
  for (i in 1:nrow(str)) {
    x<-toupper(unlist(strsplit(str[i,1], " ")))
    x<-iconv(x,to="ASCII//TRANSLIT")
    t<-paste(x[!x %in% stopwords$stopword], collapse = " ")
    lista_palavras[i,1]<-t
  }
  colnames(lista_palavras)<-c("prod_desc","doc_id")
  return(lista_palavras)
}