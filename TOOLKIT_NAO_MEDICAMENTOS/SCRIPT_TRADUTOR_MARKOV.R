#este script implementa o algoritmo que a sefaz-rs (tesouro do estado) criou, baseado em processos de markov
#Passo 1: carregar bibliotecas
##
library(data.table)
library(gtools)
library(stringr)
library(doParallel)
library(itertools)
library(RODBC)
library(slam)
library(Matrix)
library(tm)
##
#Passo 2: carregar funcoes
##
token_list<-dget("token_list.R") #esta funcao tokeniza
removeWords<-dget("removeWords.R")#esta funcao remove stopwords presentes no arquivo "STOPWORDS"
##
#Passo 3: carregar o arquivo "resultado_primeira_query.csv" - resultado da pesquisa feita no banco de dados utilizando clausula OR
##
dict<-fread("resultado_primeira_query.csv",header = TRUE,stringsAsFactors = FALSE,sep = ",")
dict$doc_id<-1:nrow(dict)
docs<-unique(dict$text)
t1<-unlist(docs,recursive = TRUE)
dictionary<-as.data.frame(cbind(t1,1:length(t1)),stringsAsFactors = FALSE)
colnames(dictionary)<-c("text","doc_id")
dictionary$text<-iconv(dictionary$text, to="ASCII//TRANSLIT")#remove acentuacao em portugues
dictionary$text<-toupper(dictionary$text)#coloca todo mundo em caixa alta
##
#Passo 4: carregar lista de produtos a precificar e lista de stopwords (tokens que deseja remover da analise)
##
lista_itens<-read.csv("lista_de_produtos.csv",header = TRUE,stringsAsFactors = FALSE,sep=";",colClasses = "character")
if(ncol(lista_itens)>2){lista_itens<-lista_itens[-(3:ncol(lista_itens))]}
stopwords<-read.csv("STOPWORDS.csv",header = TRUE,stringsAsFactors = FALSE)
##
#Passo 5: tokenizar a lista de entrada
##
lista_palavras<-removeWords(lista_itens,stopwords)
tokens<-token_list(lista_palavras)
##
#Passo 6: tradutor_markov
##
num_of_cores<-detectCores()-1
cl<-makePSOCKcluster(num_of_cores)
registerDoParallel(cl)
ptm<-proc.time()
markov_chain_prod_list<-list()
for (l in 1:nrow(lista_itens)) {
  numbers_only<-function(x)!grepl("\\D",x)
  teste<-subset(tokens[l,],str_length(tokens[l,])>0)
  teste<-subset(teste,str_length(teste)>0)
  teste<-teste[numbers_only(teste)==FALSE]
  if(length(teste)<2){
    markov_chain_prod_list[[l]]<-teste
  }else
  {
    
    vec_palavras<-teste
    Aij<-matrix(,nrow = length(vec_palavras),ncol = length(vec_palavras))
    rownames(Aij)<-c(vec_palavras[1:length(vec_palavras)])
    colnames(Aij)<-c(vec_palavras[1:length(vec_palavras)])
    dummy_dictionary<-dictionary[which(str_detect(dictionary$text,vec_palavras)==TRUE),]
    
    for (i in 1:length(vec_palavras)) {
      row.sum_p<-foreach(df=isplitRows(dummy_dictionary,chunks=num_of_cores),.combine = cbind,.packages = "stringr")%dopar%{
        dummy_list<-list()  
        for(j in 1:length(vec_palavras)){
          sub_1<-subset(df,grepl(paste(vec_palavras[i],""),df$text)==TRUE&grepl(paste(vec_palavras[j],""),df$text)==TRUE)
          sub_1<-subset(sub_1,stringr::str_locate(sub_1$text,paste(vec_palavras[i],""))[,1]<stringr::str_locate(sub_1$text,paste(vec_palavras[j],""))[,1])
          dummy_list[j]<-nrow(sub_1)
        }
        row.sum_p<-dummy_list
      }
      dummy_matrix<-matrix(,nrow = num_of_cores,ncol = length(vec_palavras))
      rownames(dummy_matrix)<-c(seq(1:num_of_cores))
      colnames(dummy_matrix)<-c(vec_palavras[1:length(vec_palavras)])
      rowsum_vec<-unlist(row.sum_p)
      contador=1
      for (k in 1:num_of_cores) {
        for (j in 1:length(vec_palavras)) {
          if(is.null(row.sum_p)==TRUE){dummy_matrix[k,j]<-0}else{
            dummy_matrix[k,j]<-rowsum_vec[contador]}
          contador=contador+1
        }
      }
      dummy_line<-colSums(dummy_matrix)
      
      for (j in 1:length(dummy_line)) {
        Aij[i,j]<-dummy_line[j]
      }
    }
    Aij[is.na(Aij)]<-0
    soma_linha<-as.vector(rowSums(Aij))
    testa_loop<-sum(soma_linha)
    for (i in 1:nrow(Aij)) {
      denominador<-soma_linha[i]
      for (j in 1:ncol(Aij)) {
        dummy<-Aij[i,j]/denominador
        if(dummy==0|is.nan(dummy)==TRUE){Aij[i,j]<-0}else{Aij[i,j]<-dummy}
        
      }
    }
    if(testa_loop!=0){
      first_token<-vec_palavras[1]
      result<-first_token
      u<-as.vector(c(rep(0,length(vec_palavras))))
      next_col=1
      u[next_col]=1
      dummy_vec<-u%*%Aij
      new_token<-colnames(dummy_vec)[max.col(dummy_vec,ties.method = "first")]
      vec_palavras<-subset(vec_palavras,(grepl(first_token,vec_palavras,fixed = TRUE)==FALSE))
      first_token<-new_token
      result<-c(result,first_token)
      dict<-subset(dummy_dictionary,grepl(paste(result[1],""),dummy_dictionary$text)==TRUE&grepl(paste(result[2],""),dummy_dictionary$text)==TRUE)
      repeat {
        next_col<-match(first_token,vec_palavras)
        u<-as.vector(c(rep(0,length(vec_palavras))))
        u[next_col]=1
        #inicio
        Aij<-matrix(,nrow = length(vec_palavras),ncol = length(vec_palavras))
        rownames(Aij)<-c(vec_palavras[1:length(vec_palavras)])
        colnames(Aij)<-c(vec_palavras[1:length(vec_palavras)])
        for (i in 1:length(vec_palavras)) {
          row.sum_p<-foreach(df=isplitRows(dict,chunks=num_of_cores),.combine = cbind,.packages = "stringr")%dopar%{
            dummy_list<-list()  
            for(j in 1:length(vec_palavras)){
              sub_1<-subset(df,grepl(paste(vec_palavras[i],""),df$text)==TRUE&grepl(paste(vec_palavras[j],""),df$text)==TRUE)
              sub_1<-subset(sub_1,stringr::str_locate(sub_1$text,paste(vec_palavras[i],""))[,1]<stringr::str_locate(sub_1$text,paste(vec_palavras[j],""))[,1])
              dummy_list[j]<-nrow(sub_1)
            }
            row.sum_p<-dummy_list
          }
          dummy_matrix<-matrix(,nrow = num_of_cores,ncol = length(vec_palavras))
          rownames(dummy_matrix)<-c(seq(1:num_of_cores))
          colnames(dummy_matrix)<-c(vec_palavras[1:length(vec_palavras)])
          rowsum_vec<-unlist(row.sum_p)
          contador=1
          for (k in 1:num_of_cores) {
            for (j in 1:length(vec_palavras)) {
              if(is.null(row.sum_p)==TRUE){dummy_matrix[k,j]<-0}else{
                dummy_matrix[k,j]<-rowsum_vec[contador]}
              contador=contador+1
            }
          }
          dummy_line<-colSums(dummy_matrix)
          
          for (j in 1:length(dummy_line)) {
            Aij[i,j]<-dummy_line[j]
          }
        }
        Aij[is.na(Aij)]<-0
        soma_linha<-as.vector(rowSums(Aij))
        testa_loop<-sum(soma_linha)
        for (i in 1:nrow(Aij)) {
          denominador<-soma_linha[i]
          for (j in 1:ncol(Aij)) {
            dummy<-Aij[i,j]/denominador
            if(dummy==0|is.nan(dummy)==TRUE){Aij[i,j]<-0}else{Aij[i,j]<-dummy}
            
          }
        }  
        #fim
        if(testa_loop==0){break}
        dummy_vec<-u%*%Aij
        if(all(dummy_vec==0)){break}
        new_token<-colnames(dummy_vec)[max.col(dummy_vec,ties.method = "first")]
        vec_palavras<-subset(vec_palavras,(grepl(first_token,vec_palavras,fixed = TRUE)==FALSE))
        if(length(vec_palavras)==0){break}
        first_token<-new_token
        #prepara teste de parada
        #inicio
        dummy_result<-c(result,first_token)
        dict<-subset(dict,grepl(paste(dummy_result[length(dummy_result)],""),dict$text)==TRUE&grepl(paste(dummy_result[length(dummy_result)-1],""),dict$text)==TRUE)
        #fim  
        if(nrow(dict)!=0){result<-c(result,first_token)}
        
        
      }
    }else{result<-c("SEM","SIMILAR","NFE")}
    
    markov_chain_prod_list[[l]]<-result
  }
}  
stopCluster(cl)
proc.time()-ptm
##
#Passo 7: cria matriz com as tokens que deverão ser utilizados na query com clausula AND
##
final_matrix<-matrix(,nrow = length(markov_chain_prod_list),ncol = 200)
for (i in 1:length(markov_chain_prod_list)) {
  lista_p<-unique(unlist(markov_chain_prod_list[i],recursive = TRUE))
  for (j in 1:length(lista_p)) {
    final_matrix[i,1]<-i#id do item
    final_matrix[i,2]<-length(lista_p)
    final_matrix[i,j+2]<-lista_p[j]
  }
}
final_matrix[is.na(final_matrix)]<-0
write.csv(final_matrix,"tokens_segunda_query.csv",row.names = FALSE)
##