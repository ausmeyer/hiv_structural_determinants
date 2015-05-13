rm(list = ls())

rates <- read.table('sites.dat', head=T, sep=',', stringsAsFactors=F)
rsa <- read.table('4tvp_trimer.rsa', head=T, stringsAsFactors=F)$RSA
distances <- read.table('4tvp_monomer_distances.dat', head=F, sep=',', stringsAsFactors=T)
map <- read.table('4tvp_structural_map.txt', head=F)

dN.dS <- rates$dNdS[map$V1 != '-']

correlations <- as.vector(sapply(distances, function(x) cor(dN.dS[x!=0], predict(lm(dN.dS[x!=0] ~ I(x[x!=0]))))))

write.table(data.frame(correlations), file= 'distance_model.correlations', row.names=F, col.names=F)
print(min(correlations)^2)
print(max(correlations)^2)
print(which(max(dN.dS) == dN.dS))

best.site <- which(max(correlations) == correlations)
print(best.site)

best.distances <- distances[best.site]

fit <- lm(dN.dS[best.distances != 0] ~ rsa[best.distances != 0] + best.distances[best.distances != 0])
print(summary(fit))