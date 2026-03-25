library(MerfishData)
library(SpatialExperiment)
library(scater)
library(DelayedArray)

# 1. Download the data
cat("Downloading data...\n")
spe <- MouseColonIbdCadinu2024()

# 2. Subset to two specific slices (Healthy vs DSS9) to keep the app fast
cat("Subsetting to specific slices...\n")
keep_cells <- (spe$mouse_id == "062921_D0_m3a" & spe$slice_id == "2") | 
              (spe$mouse_id == "062221_D9_m3" & spe$slice_id == "2")
spe_sub <- spe[, keep_cells]

# 3. Extract basic spatial/metadata for ALL cells
cat("Building full tissue map...\n")
full_tissue <- data.frame(
  x = spatialCoords(spe_sub)[,1],
  y = spatialCoords(spe_sub)[,2],
  condition = spe_sub$sample_type,
  tier1 = spe_sub$tier1,
  tier2 = spe_sub$tier2,
  cell_id = spe_sub$cell_id 
)

# 4. Zoom in on Fibroblasts ONLY
cat("Running PCA on Fibroblasts...\n")
spe_fibro <- spe_sub[, spe_sub$tier1 == "Fibroblast"]

# Run PCA (using top 500 most variable genes)
spe_fibro <- runPCA(spe_fibro, exprs_values = "logcounts", ncomponents = 2)

# Extract PC scores (coordinates)
pca_scores <- reducedDim(spe_fibro, "PCA")

# Extract Loadings (which genes drive the PCs)
pca_loadings <- attr(pca_scores, "rotation")
fibro_loadings <- as.data.frame(pca_loadings[, 1:2])
fibro_loadings$Gene <- rownames(fibro_loadings)

# 5. Extract expression of the TOP PCA GENES for the Single Gene App
cat("Extracting specific gene expressions...\n")
genes_of_interest <- c("Col1a2", "Sparc", "Dpt", "Fbn1", "Tagln", 
                       "C3", "Igfbp5", "Timp3", "Adamdec1")
genes_present <- intersect(genes_of_interest, rownames(spe_fibro))

gene_exprs <- as.matrix(logcounts(spe_fibro)[genes_present, ])
gene_exprs_df <- as.data.frame(t(gene_exprs))
gene_exprs_df$cell_id <- spe_fibro$cell_id

# 6. Merge PCA and Gene Expression back into the Fibroblast subset
fibro_df <- data.frame(
  cell_id = spe_fibro$cell_id, 
  PC1 = pca_scores[, 1],
  PC2 = pca_scores[, 2]
)

# Merge PCs into the full tissue (non-fibroblasts will have NA for PC1/PC2)
full_tissue <- merge(full_tissue, fibro_df, by = "cell_id", all.x = TRUE)

# Merge specific genes into the full tissue (non-fibroblasts will have NA)
full_tissue <- merge(full_tissue, gene_exprs_df, by = "cell_id", all.x = TRUE)

# Clean up factor levels for plotting
full_tissue$condition <- factor(full_tissue$condition, levels = c("Healthy", "DSS9"))

# 7. Save both the tissue data and the loadings as a list in one RDS file
cat("Saving data...\n")
saveRDS(list(
  tissue = full_tissue,
  loadings = fibro_loadings
), "merfish_prepared.rds")

cat("Done! Saved as merfish_prepared.rds\n")