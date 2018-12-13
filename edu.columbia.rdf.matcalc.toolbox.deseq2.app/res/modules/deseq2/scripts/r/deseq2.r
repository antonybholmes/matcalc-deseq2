if (!require("DESeq2")) {
  if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
  }
  
  BiocManager::install("DESeq2", version = "3.8")
}

library("DESeq2")


ds <- function(cts, coldata, p1, p2) {
  # the columns of interest
  cols = which(coldata$phenotype == p1 | coldata$phenotype == p2)
  
  print(paste(p1, p2))
  
  data = cts[ ,cols, drop=F]
  cd = coldata[cols,, drop=F]
  p1cols = which(cd$phenotype == p1)
  p2cols = which(cd$phenotype == p2)
  
  dds <- DESeqDataSetFromMatrix(countData = data,
                                colData = cd,
                                design = ~ phenotype)
  
  dds$phenotype = factor(dds$phenotype, c(p2, p1))
  
  dds = DESeq(dds)
  res = results(dds)
  
  # since output from deseq is not overly helpful, lets make
  # a revised table
  
  counts = counts(dds, normalized=T)
  
  p1counts = counts[, p1cols, drop=F]
  p2counts = counts[, p2cols, drop=F]
  p1means = unname(rowMeans(p1counts + 1))
  p2means = unname(rowMeans(p2counts + 1))
  fc = log2(p1means + 1) - log2(p2means + 1)
  
  df = data.frame(cbind(row.names(counts), res$pvalue, res$padj, fc, p1means, p2means))
  colnames(df) = c('Gene', 'P-value', 'FDR', 'Log2 Fold Change', paste(p1, 'Mean'), paste(p2, 'Mean'))
                   
  write.table(df, file=paste('tmp/deseq2_', p1, '_vs_', p2, '.txt', sep=''), sep='\t', col.names=T, row.names = F, quote = F)
}


cts = as.matrix(read.csv('tmp/counts.txt', sep='\t', row.names=1, header=T, check.names = F))
coldata = as.data.frame(read.csv('tmp/phenotypes.txt', sep='\t', row.names=1, header=T, check.names = F))

dds <- DESeqDataSetFromMatrix(countData = cts,
                              colData = coldata,
                              design = ~ phenotype)
dds <- estimateSizeFactors(dds)
counts = counts(dds, normalized=T)
write.table(counts, file='tmp/counts_deseq2_normalized.txt', sep='\t', col.names=NA, row.names = T, quote = F)

groups = read.csv('tmp/groups.txt', sep='\t', header=T, check.names = F, stringsAsFactors = F)

for (i in 1:dim(groups)[1]) {
  ds(cts, coldata, groups$group1[i], groups$group2[i])
}


