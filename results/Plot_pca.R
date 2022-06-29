##Set working directory
setwd("C:/Users/Amhed/Desktop/Structure")

library(ggplot2)

##Read files
fn = "HGDP_GRIDS.pca.evec"
pop = readLines("HGDP_GRIDS_pop2")

evecDat1 = read.table(fn, col.names=c("Sample", "PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", "PC8", "PC9", "PC10", "Pop"), stringsAsFactors = F)

evecDat1[,"Pop"] = pop
  
eig= readLines(fn)[1]
eigv=unlist(strsplit(eig,"\\s"))

eigv=eigv[-which(eigv=="")]
eigv=as.numeric(eigv[-1])
eigvar=100*(eigv/sum(eigv))

#make colour palette
colours <- c("#f8c471",
             "#82e0aa",
             "#73c6b6",
"#85c1e9",
"#bb8fce",
"#f1948a",
"#229954",
"#2471a3",
"#bfc9ca",
"#e59866")

colours2=colours
colours <- colours[as.factor(evecDat1$Pop)]  

#define symbols
shapes <- c(1,8,1,9,1,17,1,1,6)
shapes2=shapes
shapes <- shapes[as.factor(evecDat1$Pop)]  

#base plot 1v2
plot_1v2 <- (
  plot(evecDat1$PC1, evecDat1$PC2, col = colours, xlab=paste("PC1 (",round(eigvar[1],2),"%)",sep=""), ylab=paste("PC2 (",round(eigvar[2],2),"%)",sep=""), pch = shapes, cex = 2, lwd=1.5,
       cex.axis=1.3, cex.lab=1.2, las=1))
legend("topleft", legend = levels(as.factor(evecDat1$Pop)), col = colours2,
       pch = shapes2, cex = 1.2, bty="o", pt.cex=2, pt.lwd=1.5, scale_fill_discrete(labels = labels))
GRIDS=evecDat1[which(evecDat1$Pop=="GRIDS"),]
#points(GRIDS$PC1,GRIDS$PC2,col = "#f1948a")
#ggplot 1v2
PC1_2 <- ggplot(evecDat1, #dataset to plot
                aes(x = PC1, #x-axis is petal width
                    y = PC2, #y-axis is petal length
                    color = Pop)) + #each species is represented by a different shape
  geom_point() + #default scatter plot
  scale_shape_manual(values=shapes2)+
  theme_light() + #light theme with no grey background and with grey lines and axes
  scale_x_continuous(sec.axis = dup_axis()) + #add duplicated secondary axis on top 
  scale_y_continuous(sec.axis = dup_axis()) + #add duplicated secondary axis on right
  theme(panel.grid.major = element_blank(), #remove major gridline
        panel.grid.minor = element_blank(), #remove minor gridline
        #        legend.justification = c(0, 0), #justification is centered by default, c(1, 0) means bottom right
        #        legend.position = c(0.97, 0.01), #position relative to justification
        #        legend.background = element_rect(color = "grey"), #legend box with grey lines
        #        legend.text = element_text(face = "italic"), #since the legend is species names, display in italics
        axis.title.x.top = element_blank(), #remove top x-axis title
        axis.text.x.top = element_blank(), #remove labels on top x-axis
        axis.title.y.right = element_blank(), #remove right y-axis title
        axis.text.y.right = element_blank()) + #remove labels on right y-axis
  #scale_shape(labels = sort(unique(as.character(evecDat1$Pop))), #edit legend labels
  #            solid = FALSE) + #force hollow points to increase clarity in case of overlaps
  labs(x=paste("PC1 (",round(eigvar[1],2),"%)",sep=""), y=paste("PC2 (",round(eigvar[2],2),"%)",sep=""), #edit y-axis label
       shape = shapes2) 
  #edit legend title
PC1_2 #show plot

PC1_2 +
  geom_point(data=GRIDS,aes(x=PC1, y=PC2))
