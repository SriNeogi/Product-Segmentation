library(dplyr)
library(tidyverse)
library(stringr)
library(padr)
library(pracma)
library(cluster)
library(factoextra)

df = read.csv("Sample_Market_SKU_data.csv")
n=ncol(df)
df[is.na(df)] <- 0
#Remove the non-numeric columns
df2 = as.matrix(df[,3:n])

#####Find mean vol and COV for each time series, row-wise operation
M1 = matrix(nrow = nrow(df2), ncol = 2)	
for (i in 1:nrow(df2))
{
  M1[i,1] = mean(df2[i,which.max(df2[i,] != 0):length(df2[i,])])
  M1[i,2] = sd(df2[i,which.max(df2[i,] != 0):length(df2[i,])])
}
View(M1)

#Create 2 new columns: COV and MeanVol
colnames(M1) = c("MeanVol","SD")
M1d = data.frame(M1)
M2d = M1d %>% mutate(Cov=SD/MeanVol)
M3d = M2d %>% select(Cov, MeanVol)
M4d = cbind(df[,1:2],M3d)
View(M4d)
n=ncol(df)

#Run the CLUSTER ANALYSIS MODEL
#Find the number of clusters with elbow plot
fviz_nbclust(M3d,kmeans,method="silhouette") + geom_vline(xintercept=0,linetype=1) + ggtitle("Elbow Plot")
#Plug the number in the kmeans function
km.res1 = kmeans(M3d,4,nstart=25)
#Create the cluster plot
fviz_cluster(km.res1,data=M3d,ggtheme=theme_minimal(),main="Cluster plot",repel = TRUE)+geom_vline(xintercept=0,linetype=2)+geom_hline(yintercept=0,linetype=2)
#Add the cluster number to each row
aggregate(M3d,by=list(cluster=km.res1$cluster),mean)
df1 = cbind(M3d,km.res1$cluster)
#Is the COV high or low? Add another column at the end called CoVClass
df2 = df1 %>%  mutate(CoVClass= if_else(Cov>=1,'HighCov','LowCoV'))
#Final data with Market and SKU details
df3 = cbind(df[,1:2],df2)