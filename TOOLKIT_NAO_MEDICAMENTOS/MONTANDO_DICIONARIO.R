#THIS SCRIPT SELECTS THE TOKENS TO BE USED IN THE QUERY ###### THIS QUERY MUST USE OR CLAUSE
#load the required functions
#set the working directory before running
      setwd("Y:/PIPELINE/DEMANDAS_ESPECIFICAS/BID_MANUAL_TECNICO/R")
      token_list<-dget("token_list.R")
      removeWords<-dget("removeWords.R")
#
#load stopwords list and products list
#set the working directory before running
      setwd("Y:/PIPELINE/DEMANDAS_ESPECIFICAS/BID_MANUAL_TECNICO/DADOS_DE_ENTRADA")
      stopwords<-read.csv("STOPWORDS.csv",header = TRUE,stringsAsFactors = FALSE)
      lista_itens<-read.csv("lista_de_produtos.csv",header = TRUE,stringsAsFactors = FALSE,sep=";",colClasses = "character")
      if(ncol(lista_itens)>2){lista_itens<-lista_itens[-(3:ncol(lista_itens))]}
#tokenize
      lista_palavras<-removeWords(lista_itens,stopwords)
      tokens<-token_list(lista_palavras)
      setwd("Y:/PIPELINE/DEMANDAS_ESPECIFICAS/BID_MANUAL_TECNICO/CONJUNTOS_DE_DADOS")
      lista<-list()
      for (i in 1:nrow(lista_palavras)) {
        lista[[i]] <- subset(tokens[i,],str_length(tokens[i,])>1)
      }
      lista_query<-unique(unlist(lista,recursive = TRUE))
      lista_query<-gsub("'","''",lista_query,fixed = TRUE)
      lista_query<-gsub("[[:punct:][:blank:]]+", " ", lista_query)
      numbers_only<-function(x)!grepl("\\D",x)
      dummy_list<-gsub(" ","",lista_query,fixed = TRUE)
      lista_query<-dummy_list[numbers_only(dummy_list)==FALSE]
      vec_palavras<-matrix(,nrow =length(lista_query),ncol = 2)
      colnames(vec_palavras)<-c("IdControleExtracao","xProd")
      j=1
      for (i in 1:length(lista_query)) {
        if(lista_query[i]!=""){
          vec_palavras[j,2]<-lista_query[i]
          vec_palavras[j,1]<-unlist(IdControleExtracao)
          j<-j+1
        }
      }
      vec_IdControleExtracao<-as.numeric(vec_palavras[,1])
      vec_token<-vec_palavras[,2]
      write.csv(vec_token,"palavras_busca_banco.csv",row.names = FALSE)