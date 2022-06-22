#load required R packages
#
library(data.table)
library(dplyr)
library(bit64)
library(stringr)
#

#load the file
dose_1KG<-fread("resultado_segunda_query.csv",stringsAsFactors = FALSE)
#use regular expression to select only 1 kg packages
dose_1KG<-subset(dose_1KG,(grepl(" 1KG ",dose_1KG$DESCRICAO,fixed = TRUE) == TRUE) | (grepl(" 1 KG ",dose_1KG$DESCRICAO,fixed = TRUE) == TRUE) )
#running bootstrap to evaluate reference price
dataset<-dose_1KG
set.seed(123)
brks<-with(dataset,quantile(dataset$QUANTIDADE,probs = c(0,0.25,0.5,0.75,1)))
inferior<-quantile(as.numeric(dataset$VALOR_UNITARIO),0.25)-1.5*IQR(as.numeric(dataset$VALOR_UNITARIO))
superior<-quantile(as.numeric(dataset$VALOR_UNITARIO),0.75)+1.5*IQR(as.numeric(dataset$VALOR_UNITARIO))
final_set<-dataset[as.numeric(dataset$VALOR_UNITARIO)<=superior&as.numeric(dataset$VALOR_UNITARIO)>=inferior,]
n = nrow(final_set)
median(as.numeric(dataset$VALOR_UNITARIO))
namostras = 1000
amostras.boot = replicate(namostras, sample(as.numeric(dataset$VALOR_UNITARIO), n, replace=T))
med = apply(amostras.boot, 2, median)
dif=med-median(as.numeric(dataset$VALOR_UNITARIO))
nivel_sig=0.90
z=1.645
d=quantile(dif,c((0.5-(nivel_sig/2)),(0.5+(nivel_sig/2))))
ic_PRM_geral=c((median(as.numeric(dataset$VALOR_UNITARIO))-abs(d[1])),(median(as.numeric(dataset$VALOR_UNITARIO))+abs(d[2])))
n0=round((((z^2)*(var(as.numeric(dataset$VALOR_UNITARIO))/(median(as.numeric(dataset$VALOR_UNITARIO))^2)))/(0.1^2)),0)
median(as.numeric(dataset$VALOR_UNITARIO))
PRM_geral=median(as.numeric(dataset$VALOR_UNITARIO))
Geral_quantidade_media=mean(dataset$QUANTIDADE)
