##Select working directory
setwd("C:/Users/Amhed/OneDrive/Desktop/GRID_test")

##read snp frequencies
tt=read.table("Snp_probability.tsv",sep="\t",header=F)

colnames(tt)=c("id","in","out","freq")

##Some alleles are fixed (i.e. present in all the population, that leads to NAs in out)
tt[is.na(tt[,"out"]),"out"]=rep(0,sum(is.na(tt[,"out"])))
##I should add a seed to maintain analysis comparable
set.seed(42)

mat=matrix( nrow = nrow(tt), ncol = 1575)

for(i in 1:nrow(mat)){
  mat[i,]=sample(x = c(rep(1,tt[i,"in"]),rep(0,tt[i,"out"])), size = 1575, replace = FALSE)
}

##Cool, now lets save it into a table for future reference
write.table(mat,"simulated_data.tsv",sep="\t",row.names = as.character(tt[,1]), col.names = FALSE)

##Ok, first lets try a simple bootstrap approach, for that lets convert the matrix to a logical value
newmat= (mat == 1)
##Then

##Im forgetting (should've sleep more and annotate what I wanted to do) why I wanted logical values. I know is to compare
##Right, to check at N events I just have to create a random sequence with no replacement
#Then I start from one
#Then sum, then next sequence I jsut make and OR, then sum, then again, then again, till sample was completed, cool
##Also, as each comparison is independent I can multithreat this, in c++ or matlab will be cool as well, but vector operations seems easier in R

bootstraps=1000
individuals=1575
resmat=matrix(0,nrow=bootstraps, ncol=individuals)
#Just in case need for comparable results
set.seed(42)

for(i in 1:nrow(resmat)){
  seq=sample(1:individuals,size = individuals,replace=FALSE)
  ##Technically this provides first appearance; I could also make a function that retrieves the sum at each point, basically a two loop summing at every pos but that sounds inneficient.. can try it thouhg
  dat=table(apply(newmat[,seq],1,function(x){which.max(x)}))
  resmat[i,as.integer(names(dat))]=dat
}

##resmat have now the increments, to get the cumulative plot I can apply now cumsum
bootmat=t(apply(resmat,1,cumsum))


##Lets save increments just in case
write.table(resmat,"simulated_data_1K_boostraps.tsv",sep="\t",row.names = FALSE, col.names = FALSE)

##Ok, now by individual performed I can make confidence intervals
##maybe

##Yup it works
testis=apply(bootmat,2,summary)

##Cumulative bootstraps
##But better do things by separated
MedBoot=apply(bootmat,2,median)
SdBoot=apply(bootmat,2,sd)

plot(1:individuals,MedBoot,type="l",col="black")
points(1:individuals,c(MedBoot + SdBoot),col="red")
points(1:individuals,c(MedBoot - SdBoot),col="red")

##Number of segregation sites as function of genomes sequenced
MedRes=apply(resmat,2,median)
SdRes=apply(resmat,2,sd)

plot(1:individuals,MedRes,type="l",col="black")
points(1:individuals,c(MedRes + SdRes),col="red")
points(1:individuals,c(MedRes - SdRes),col="red")

##What about if I asume a pop larger than 10
plot(11:individuals,MedRes[-c(1:10)],type="l",col="black")
points(11:individuals,c(MedRes[-c(1:10)] + SdRes[-c(1:10)]),col="red")
points(11:individuals,c(MedRes[-c(1:10)] - SdRes[-c(1:10)]),col="red")

##What about if I asume a pop larger than 100
plot(101:individuals,MedRes[-c(1:100)],type="l",col="black")
points(101:individuals,c(MedRes[-c(1:100)] + SdRes[-c(1:100)]),col="red")
points(101:individuals,c(MedRes[-c(1:100)] - SdRes[-c(1:100)]),col="red")

##What about if I asume a pop larger than 50
plot(51:individuals,MedRes[-c(1:50)],type="l",col="black")
points(51:individuals,c(MedRes[-c(1:50)] + SdRes[-c(1:50)]),col="red")
points(51:individuals,c(MedRes[-c(1:50)] - SdRes[-c(1:50)]),col="blue")



###Ok, new approach to compare
bootstraps=100
individuals=1575
resmat=matrix(0,nrow=bootstraps, ncol=individuals)
otmat=matrix(0,nrow=bootstraps, ncol=individuals)
#Just in case need for comparable results
set.seed(42)

for(i in 1:nrow(resmat)){
  seq=sample(1:individuals,size = individuals,replace=FALSE)
  ##Technically this provides first appearance; I could also make a function that retrieves the sum at each point, basically a two loop summing at every pos but that sounds inneficient.. can try it thouhg
  dat=table(apply(newmat[,seq],1,function(x){which.max(x)}))
  resmat[i,as.integer(names(dat))]=dat
  nd=c()
  vals=rep(FALSE,nrow(newmat))
  for(j in seq){
    vals=(vals|newmat[,j])
    nd=append(nd,sum(vals))
  }
  otmat[i,]=nd
}

###otmat should contain only the values but not the increments so lets see if my prev approach produces the same matrix
##resmat have now the increments, to get the cumulative plot I can apply now cumsum
bootmat=t(apply(resmat,1,cumsum))
bootmat[,1] == otmat[,1]
bootmat[,2] == otmat[,2]

##No need for double loops just applies, also these can be easily parallelized

##Lets try now with real data
mat=as.matrix( read.table("ApearingSnps.tsv",sep="\t",header=F))
newmat= (mat == 1)

bootstraps=100
individuals=ncol(mat)
resmat=matrix(0,nrow=bootstraps, ncol=individuals)
#Just in case need for comparable results
set.seed(42)

for(i in 1:nrow(resmat)){
  seq=sample(1:individuals,size = individuals,replace=FALSE)
  dat=table(apply(newmat[,seq],1,function(x){which.max(x)}))
  resmat[i,as.integer(names(dat))]=dat
}

##resmat have now the increments, to get the cumulative plot I can apply now cumsum
bootmat=t(apply(resmat,1,cumsum))
MedBoot=apply(bootmat,2,median)
SdBoot=apply(bootmat,2,sd)

plot(1:individuals,MedBoot,type="l",col="black")
points(1:individuals,c(MedBoot + SdBoot),col="red")
points(1:individuals,c(MedBoot - SdBoot),col="red")

##Number of segregation sites as function of genomes sequenced
MedRes=apply(resmat,2,median)
SdRes=apply(resmat,2,sd)

plot(1:individuals,MedRes,type="l",col="black")
points(1:individuals,c(MedRes + SdRes),col="red")
points(1:individuals,c(MedRes - SdRes),col="red")

##What about if I asume a pop larger than 10
plot(11:individuals,MedRes[-c(1:10)],type="l",col="black")
points(11:individuals,c(MedRes[-c(1:10)] + SdRes[-c(1:10)]),col="red")
points(11:individuals,c(MedRes[-c(1:10)] - SdRes[-c(1:10)]),col="red")

##What about if I asume a pop larger than 100
plot(101:individuals,MedRes[-c(1:100)],type="l",col="black")
points(101:individuals,c(MedRes[-c(1:100)] + SdRes[-c(1:100)]),col="red")
points(101:individuals,c(MedRes[-c(1:100)] - SdRes[-c(1:100)]),col="red")

##What about if I asume a pop larger than 50
plot(51:individuals,MedRes[-c(1:50)],type="l",col="black")
points(51:individuals,c(MedRes[-c(1:50)] + SdRes[-c(1:50)]),col="red")
points(51:individuals,c(MedRes[-c(1:50)] - SdRes[-c(1:50)]),col="blue")

##What about if I asume a pop larger than 50
plot(88:individuals,MedRes[-c(1:87)],type="l",col="black")
points(88:individuals,c(MedRes[-c(1:87)] + SdRes[-c(1:87)]),col="red")
points(88:individuals,c(MedRes[-c(1:87)] - SdRes[-c(1:87)]),col="blue")

#
##What about if I asume a pop larger than 50
plot(1:90,MedRes[c(1:90)],type="l",col="black")
points(1:90,c(MedRes[1:90] + SdRes[1:90]),col="red")
points(1:90,c(MedRes[1:90] - SdRes[1:90]),col="blue")


mat=as.matrix( read.table("ApearingSnps.tsv",sep="\t",header=F))
torem=apply(mat,1,function(x){sum(x,na.rm = T)})
torem=which(torem==0)
mat=mat[-torem,]
newmat= (mat == 1)

##Apparently there's some snps not with frequency 0 in the dataset. How is that even possible?
#I can use plink to get the frequencies though
freqs=apply(newmat,1,function(x){sum(x,na.rm = T)/length(x)})
exp=1/freqs
Seens=table(round(exp))

plot(as.integer(names(Seens)),as.integer(Seens))
max(Seens)


bootstraps=100
individuals=ncol(mat)
resmat=matrix(0,nrow=bootstraps, ncol=individuals)
#Just in case need for comparable results
set.seed(42)

for(i in 1:nrow(resmat)){
  seq=sample(1:individuals,size = individuals,replace=FALSE)
  dat=table(apply(newmat[,seq],1,function(x){which.max(x)}))
  resmat[i,as.integer(names(dat))]=dat
}

##resmat have now the increments, to get the cumulative plot I can apply now cumsum
bootmat=t(apply(resmat,1,cumsum))
MedBoot=apply(bootmat,2,median)
SdBoot=apply(bootmat,2,sd)

plot(1:individuals,MedBoot,type="l",col="black")
points(1:individuals,c(MedBoot + SdBoot),col="red")
points(1:individuals,c(MedBoot - SdBoot),col="red")

##Number of segregation sites as function of genomes sequenced
MedRes=apply(resmat,2,median)
SdRes=apply(resmat,2,sd)

plot(1:individuals,MedRes,type="l",col="black")
points(1:individuals,c(MedRes + SdRes),col="red")
points(1:individuals,c(MedRes - SdRes),col="red")
