library(ape)

tree <- read.tree("data/plastome_seq/plastome.fasta.concat.treefile")

# reroot, ladderise
outgroup <- getMRCA(tree,
                    grep("Spondianthus|U_", tree$tip.label))
tree <- root.phylo(tree, node = outgroup)
tree <- ladderize(tree, right = FALSE)

# plot to PDF
pdf(width = 10, height = 16,
    file = "figures/plastome_tree.iqtree.pdf")
par(mar = c(0,0,0,0))
plot.phylo(tree, cex = 1, label.offset = 0.0001, underscore = TRUE, font = 1)
nodelabels(tree$node.label, cex = 0.5)
dev.off()

