library(ggplot2)
library(cowplot)

setwd('~/Google Drive/Documents/PostDoc/HIVStructuralDeterminants/hiv_structural_determinants/data/combined_figures/')

r.value.1 <- 0.1001862
r.free.1 <- 0.09242819
r.rsa.1 <- 0.05076719
mean.dN.dS.1 <- 0.2
r.1 <- "Capsid"

r.value.2 <- 0.3716488
r.free.2 <- 0.3637618
r.rsa.2 <- 0.1812471
mean.dN.dS.2 <- 0.7836029
r.2 <- "gp120"

r.value.3 <- 0.1325805
r.free.3 <- 0.09904008
r.rsa.3 <- 0.0609476
mean.dN.dS.3 <- 0.5024948
r.3 <- "Matrix"

r.value.4 <- 0.02647536
r.free.4 <- 0.02928405
r.rsa.4 <- 0.003255963
mean.dN.dS.4 <- 0.1889462
r.4 <- "Integrase"

r.value.5 <- 0.3104171
r.free.5 <- 0.3069456
r.rsa.5 <- 0.04737184
mean.dN.dS.5 <- 0.2619128
r.5 <- "Protease"

r.value.6 <- 0.06046455
r.free.6 <- 0.05723965
r.rsa.6 <- 0.04350685
mean.dN.dS.6 <- 0.2514634
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
  xlab("Protein") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
  scale_y_continuous(limits = c(0, 0.4))

ggsave("r_squared.png", p, width=7.5, height=7.5)

df.comp <- data.frame(x = df$r.square[df$r.type == 'Combined - Training'], y = df$r.square[df$r.type == 'Combined - Test'], Protein = df$names[df$r.type == 'Combined - Test'])

p <- ggplot(aes(x = x, y = y, colour=Protein), data = df.comp) +
  geom_point(size=8) +
  ylab(expression(paste("Combined Model - Test (R"^"2", ')', sep=''))) +
  xlab(expression(paste("RSA - only (R"^"2", ')', sep=''))) +
  scale_x_continuous(limits = c(0, 0.4)) +
  scale_y_continuous(limits = c(0, 0.4))

ggsave("CombinedVRSA.png", p, width=7.5, height=5.5)