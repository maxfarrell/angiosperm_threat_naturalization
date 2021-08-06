# https://bio.libretexts.org/Bookshelves/Evolutionary_Developmental_Biology/Book%3A_Phylogenetic_Comparative_Methods_(Harmon)/11%3A_Fitting_Birth-Death_Models/11.02%3A_Clade_Age_and_Diversity
library(ape)

# tree <- read.nexus("Magallon_etal_PL_ML.nex")
tree <- read.tree("Magellon_etal_PL_ML_pruned.tre")
tree$tip.label

data <- read.csv("sp.threat.nat.csv")
data$family

#extract family stem ages
ages<-NULL
for (x in 1: length(tree$tip.label)){
sp<-tree$tip.label[x]
edge<-tree$edge.length[tree$edge[,2]==x]
ages<-rbind(ages,(data.frame(sp,edge)))
}

data.rates <- merge(data, ages,by.x="family", by.y = "sp")
#eugh my numerics edge lengths have been converted to factors
data.rates$edge<-as.numeric(as.character(data.rates$edge))

#sanity check
head(ages[order(ages$sp),])
head(data.rates)


#Calculate rates assuming different extinction fractions (e)
e<-0
r0<-log(data.rates$species*(1-e)+e)/data.rates$edge

e<-0.5
r0.5<-log(data.rates$species*(1-e)+e)/data.rates$edge

e<-0.9
r0.9<-log(data.rates$species*(1-e)+e)/data.rates$edge

#just for a quick look-see
plot(r0, r0.9)

data.rates<-cbind(data.rates, r0, r0.5, r0.9)
#write.csv(data.rates, file = "sp.threat.nat.new.rates.csv")