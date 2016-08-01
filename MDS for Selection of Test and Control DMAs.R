#Set the working directory
setwd('E://StorageSync//Grainger Files//2016//Projects//PPC Incremental Test//')

#Load the libraries we need
library(ggplot2)
library(car)

#Read in the data we want to analyze
dma<-read.table('DMA MDS Metrics.dat',sep='\t',header=TRUE)

#Calculate the growth percentage of 12M GIS sales
dma$gis_sg_pct<-( (dma$SALES12X - dma$SALES24X) / dma$SALES24X ) * 100
dma$gcom_sg_pct<-( (dma$GCOM12X - dma$GCOM24X) / dma$GCOM24X ) * 100

###MDS STANDARDIZING VARIABLES BEFORE DISTANCE AND ADDING IN BPG VARIABLES###

#Store only the variables we wish to use for the distance calculation
dma_mds<-dma[,c(1:34,38,42,44:47)]

#Scale each of the continuous variables
dma_mds_std<-cbind(dma_mds[,1:3],
                   data.frame(lapply(dma_mds[,c(4:33)],function(x) 
                      recode(x,'0 = - 4; 1 = 4',as.numeric.result = TRUE))),
                    scale(dma_mds[,34:40]))

#Get the distance matrix using euclidean distances
dma_mds_dist<-dist(dma_mds_std[,4:40],method="euclidean")

#Perform PCA on the distance matrix to scale it to two dimensions
dma_mds_fit<-cmdscale(dma_mds_dist,eig=TRUE,k=2)

#Store the results
dma_mds_res<-cbind(dma_mds_std[,c(1:3)],dma_mds_fit$points[,1:2])

colnames(dma_mds_res)[4:5]<-c("Dim1","Dim2")

#Before plotting remove any DMAs in large markets or which are part of the radio
#test in Q3 2016
dma_mds_res2<-dma_mds_res[which(dma_mds_res$DMA_ID != 8  & 
                                dma_mds_res$DMA_ID != 9  &
                                dma_mds_res$DMA_ID != 13 &
                                dma_mds_res$DMA_ID != 24 &
                                dma_mds_res$DMA_ID != 26 &
                                dma_mds_res$DMA_ID != 27 &
                                dma_mds_res$DMA_ID != 31 &
                                dma_mds_res$DMA_ID != 38 &
                                dma_mds_res$DMA_ID != 43 &
                                dma_mds_res$DMA_ID != 45 &
                                dma_mds_res$DMA_ID != 52 &
                                dma_mds_res$DMA_ID != 54 &
                                dma_mds_res$DMA_ID != 55 &
                                dma_mds_res$DMA_ID != 64 &
                                dma_mds_res$DMA_ID != 87 &
                                dma_mds_res$DMA_ID != 91 &
                                dma_mds_res$DMA_ID != 99 &
                                dma_mds_res$DMA_ID != 112 &
                                dma_mds_res$DMA_ID != 120 &
                                dma_mds_res$DMA_ID != 124 &
                                dma_mds_res$DMA_ID != 134 &
                                dma_mds_res$DMA_ID != 147 &
                                dma_mds_res$DMA_ID != 148 &
                                dma_mds_res$DMA_ID != 149 &
                                dma_mds_res$DMA_ID != 150 &
                                dma_mds_res$DMA_ID != 160 &
                                dma_mds_res$DMA_ID != 162 &
                                dma_mds_res$DMA_ID != 168 &
                                dma_mds_res$DMA_ID != 169 &
                                dma_mds_res$DMA_ID != 176 &
                                dma_mds_res$DMA_ID != 177 &
                                dma_mds_res$DMA_ID != 187),]

#Plot the results
ggplot(dma_mds_res2,aes(Dim1,Dim2)) + 
  geom_point(aes(colour=factor(final_cluster)),size=4,) +
  geom_text(aes(label=DMA_ID,x=Dim1 - 0.1,y=Dim2),size=3) +
  ggtitle("Similarity of DMAs") +
  labs(x="Dim1",y="Dim2")

#Zoom into peer group at bottom of the chart
dma_mds_g1<-dma_mds_res2[which(dma_mds_res2$Dim1 > 0 &
                                  dma_mds_res2$Dim2 < -1),]

ggplot(dma_mds_g1,aes(Dim1,Dim2)) + 
  geom_point(aes(colour=factor(final_cluster)),size=4,) +
  geom_text(aes(label=DMA_ID,x=Dim1 - 0.05,y=Dim2),size=3) +
  ggtitle("Similarity of DMAs") +
  labs(x="Dim1",y="Dim2")

#Zoom into main cluster at bottom of the chart
dma_mds_g2<-dma_mds_res2[which(dma_mds_res2$Dim1 < 0 &
                               dma_mds_res2$Dim2 < 0),]

ggplot(dma_mds_g2,aes(Dim1,Dim2)) + 
  geom_point(aes(colour=factor(final_cluster)),size=4,) +
  geom_text(aes(label=DMA_ID,x=Dim1 - 0.05,y=Dim2),size=3) +
  ggtitle("Similarity of DMAs") +
  labs(x="Dim1",y="Dim2")

#Zoom into clusters 7 and 23
dma_mds_g3<-dma_mds_res2[which(dma_mds_res2$Dim1 < -1.5 &
                               dma_mds_res2$Dim2 > -1.2 &
                               dma_mds_res2$Dim2 < 0),]

ggplot(dma_mds_g3,aes(Dim1,Dim2)) + 
  geom_point(aes(colour=factor(final_cluster)),size=4,) +
  geom_text(aes(label=DMA_ID,x=Dim1 - 0.01,y=Dim2),size=3) +
  ggtitle("Similarity of DMAs") +
  labs(x="Dim1",y="Dim2")

#Zoom into cluster 9
dma_mds_g4<-dma_mds_res2[which(dma_mds_res2$Dim1 < -1 &
                               dma_mds_res2$Dim1 > -2 &
                               dma_mds_res2$Dim2 < -1.2),]

ggplot(dma_mds_g4,aes(Dim1,Dim2)) + 
  geom_point(aes(colour=factor(final_cluster)),size=4,) +
  geom_text(aes(label=DMA_ID,x=Dim1 - 0.01,y=Dim2),size=3) +
  ggtitle("Similarity of DMAs") +
  labs(x="Dim1",y="Dim2")

#Zoom into clusters 14 and 16
dma_mds_g5<-dma_mds_res2[which(dma_mds_res2$Dim1 < 0 &
                               dma_mds_res2$Dim1 > -1.5 &
                               dma_mds_res2$Dim2 > -1.1 &
                               dma_mds_res2$Dim2 < -0.8),]

ggplot(dma_mds_g5,aes(Dim1,Dim2)) + 
  geom_point(aes(colour=factor(final_cluster)),size=4,) +
  geom_text(aes(label=DMA_ID,x=Dim1 - 0.01,y=Dim2),size=3) +
  ggtitle("Similarity of DMAs") +
  labs(x="Dim1",y="Dim2")

