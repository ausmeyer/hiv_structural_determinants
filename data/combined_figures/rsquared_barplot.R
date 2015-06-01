rm(list = ls())

library(ggplot2)
library(cowplot)

setwd('~/Google Drive/Documents/PostDoc/HIVStructuralDeterminants/hiv_structural_determinants/data/combined_figures/')

get.rates <- function(location) {
  rates <- read.table(paste(location, 'sites.dat', sep=''), sep=',', head=T)
  map <- read.table(paste(location, 'aas.fasta.map', sep=''), sep=',', head=F, stringsAsFactors=F)
  keep.alignment.sites <- map$V3[map$V3 != '-']
  return(rates$dN.dS[as.numeric(keep.alignment.sites)])
}

plot.histogram <- function(data) {
  p.tmp <- ggplot(data = data.frame(x=data), aes(x=x)) + geom_density(fill='gray') +
    scale_x_continuous(limits = c(0, 4)) +
    scale_y_continuous(limits = c(0, 7)) + 
    xlab('dN/dS') +
    ylab('Probability Density') +
    geom_vline(xintercept = 1, linetype = "longdash")
}

r.value.1 <- 0.1001862
r.free.1 <- 0.09242819
r.rsa.1 <- 0.05076719
rates.1 <- get.rates('../capsid/capsid_structure/predictors/')
mean.dN.dS.1 <- mean(rates.1)
p.1 <- plot.histogram(rates.1)
r.1 <- "Capsid"

r.value.2 <- 0.3716488
r.free.2 <- 0.3637618
r.rsa.2 <- 0.1812471
rates.2 <- get.rates('../gp120/gp120_structure/predictors/')
mean.dN.dS.2 <- mean(rates.2)
p.2 <- plot.histogram(rates.2)
r.2 <- "gp120"

r.value.3 <- 0.1325805
r.free.3 <- 0.09904008
r.rsa.3 <- 0.0609476
rates.3 <- get.rates('../matrix/matrix_structure/predictors/')
mean.dN.dS.3 <- mean(rates.3)
p.3 <- plot.histogram(rates.3)
r.3 <- "Matrix"

r.value.4 <- 0.02647536
r.free.4 <- 0.02928405
r.rsa.4 <- 0.003255963
rates.4 <- get.rates('../integrase/integrase_structures/predictors/')
mean.dN.dS.4 <- mean(rates.4)
p.4 <- plot.histogram(rates.4)
r.4 <- "Integrase"

r.value.5 <- 0.3104171
r.free.5 <- 0.3069456
r.rsa.5 <- 0.04737184
rates.5 <- get.rates('../protease/protease_structure/predictors/')
mean.dN.dS.5 <- mean(rates.5)
p.5 <- plot.histogram(rates.5)
r.5 <- "Protease"

r.value.6 <- 0.06046455
r.free.6 <- 0.05723965
r.rsa.6 <- 0.04350685
rates.6 <- get.rates('../reverse_transcriptase/rt_structures/predictors/')
mean.dN.dS.6 <- mean(rates.6)
p.6 <- plot.histogram(rates.6)
r.6 <- "Reverse Transcriptase"

print(mean(r.value.1, r.value.2, r.value.3, r.value.4, r.value.5, r.value.6))
print(mean(r.free.1, r.free.2, r.free.3, r.free.4, r.free.5, r.free.6))
print(mean(r.rsa.1, r.rsa.2, r.rsa.3, r.rsa.4, r.rsa.5, r.rsa.6))

rs <- c(r.value.1, r.free.1, r.rsa.1, 
        r.value.2, r.free.2, r.rsa.2, 
        r.value.3, r.free.3, r.rsa.3, 
        r.value.4, r.free.4, r.rsa.4, 
        r.value.5, r.free.5, r.rsa.5, 
        r.value.6, r.free.6, r.rsa.6)

r.names <- c(r.1, r.1, r.1,
             r.2, r.2, r.2,
             r.3, r.3, r.3,
             r.4, r.4, r.4, 
             r.5, r.5, r.5,
             r.6, r.6, r.6)
r.names <- factor(r.names, levels=r.names)

r.type <- rep(c('Combined - Training', 'Combined - Test', 'RSA - only'), 6)
r.type <- factor(r.type, levels=r.type)

df <- data.frame(r.square = rs, names = r.names, r.type = r.type, stringsAsFactors = F)

p <- ggplot(aes(x = names, y = r.square, fill=r.type, colour=NULL), data = df) +
  geom_bar(stat = 'identity', position=position_dodge()) +
  scale_fill_hue(name="Model Type") +
  ylab(expression(paste("Variance Explained (R"^"2", ')', sep=''))) +
  xlab("") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
  scale_y_continuous(limits = c(0, 0.4))

ggsave("r_squared.png", p, width=7.5, height=7.5)

df.comp <- data.frame(x = df$r.square[df$r.type == 'RSA - only'], y = df$r.square[df$r.type == 'Combined - Test'], Protein = df$names[df$r.type == 'Combined - Test'])

p <- ggplot(aes(x = x, y = y, colour=Protein), data = df.comp) +
  geom_point(size=4) +
  ylab(expression(paste("Combined Model - Test (R"^"2", ')', sep=''))) +
  xlab(expression(paste("RSA - only (R"^"2", ')', sep=''))) +
  scale_x_continuous(limits = c(0, 0.2)) +
  scale_y_continuous(limits = c(0, 0.4))

ggsave("combined_RSA.png", p, width=7.5, height=5.5)

p <- plot_grid(p.1, p.2, p.3, p.4, p.5, p.6, ncol = 2, labels = c('A', 'B', 'C', 'D', 'E', 'F'))
ggsave("rate_distribution.png", p, width=8, height=12)

