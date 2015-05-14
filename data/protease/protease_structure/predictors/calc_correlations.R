rm(list = ls())

rates <- read.table('sites.dat', head=T, sep=',', stringsAsFactors=F)
rsa <- read.table('1HPV_dimer.rsa', head=T, stringsAsFactors=F)$RSA
distances <- read.table('distances.dat', head=F, sep=',', stringsAsFactors=T)
map <- read.table('aas.fasta.map', head=F, stringsAsFactors=F)

dN.dS <- rates$dN.dS[map$V3]
best.site <- c()
best.r <- c()
rfree <- c()

for(i in 1:100) {
  small.set <- sample(1:length(dN.dS), length(dN.dS)*0.75)
  fit.dN.dS <- dN.dS[small.set]
  fit.distances <- distances[small.set, ]
  fit.rsa <- rsa[small.set]
  
  fit.correlations <- as.vector(sapply(1:ncol(fit.distances), function(x) cor(fit.dN.dS, 
                                                                              predict(lm(fit.dN.dS ~ fit.rsa + fit.distances[, x])))))
  
  best <- which(fit.correlations^2 == max(fit.correlations^2))
  best.site <- append(best.site, best)
  
  free.dN.dS <- dN.dS[-small.set]
  free.distances <- distances[-small.set, best]
  free.rsa <- rsa[-small.set]
  
  free.correlations <- cor(free.dN.dS, 
                           predict(lm(free.dN.dS ~ free.rsa + free.distances)))
  
  best.r <- append(best.r, max(fit.correlations^2))
  rfree <- append(rfree, max(free.correlations^2))
}

print(mean(best.r))
print(mean(rfree))
print(table(best.site))

fit.site <- as.numeric(names(sort(-table(best.site)))[1])
fit <- lm(dN.dS ~ rsa + distances[, fit.site])
print(summary(fit))

correlations <- as.vector(sapply(1:ncol(distances), function(x) cor(dN.dS, 
                                                                    predict(lm(dN.dS ~ distances[, x])))))
write.table(data.frame(correlations), file= 'distance_model.correlations', row.names=F, col.names=F)
