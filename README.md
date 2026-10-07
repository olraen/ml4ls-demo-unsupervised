# ml4ls-demo-unsupervised

Unsupervised machine-learning example for exploring subgroups in simulated gene-expression data and investigating how the resulting clusters differ in clinical characteristics.

The project was developed as a teaching example for the **Machine Learning for Life Sciences** course.

## Research question

Can we identify subgroups of individuals based only on gene-expression profiles, and do those subgroups differ in clinical characteristics?

Examples of follow-up questions include:

- Do clusters differ in BMI, glucose, HbA1c, lipids or age?
- Are some clusters enriched for individuals with BMI > 30?
- Which genes characterise the different clusters?

## Data

The project uses two datasets:

- `data/data-diabetes.csv` — clinical data based on the `diabetes` dataset from the R package `faraway`
- `data/data-diabetes-genes.csv` — simulated gene-expression measurements

The gene-expression dataset contains approximately 1,000 genes. A subset of genes contains simulated signal related to BMI, while the remaining genes mainly represent noise.

The data are intended for teaching purposes only.

## Analysis

The complete analysis is contained in:

`analysis.qmd`

The workflow includes:

1. Explore the clinical and gene-expression data.
2. Examine and handle missing data.
3. Perform PCA on the gene-expression measurements.
4. Retain the first 30 principal components for clustering.
5. Identify groups using k-means clustering.
6. Characterise the resulting clusters using clinical variables.
7. Identify genes that differ most between each cluster and the overall expression profile.
8. Save the processed clustering results for use by the Shiny application.

Clinical variables are **not used to define the clusters**. They are used after clustering to explore and interpret the groups identified from gene-expression data.

## Interactive application

The Shiny application allows users to:

- visualise the gene-expression clusters in PCA space
- select clinical variables and compare them across clusters
- explore genes that characterise each cluster

Run the application locally with:

```r
shiny::runApp()
```

or access the deployed version online:

[https://olraen-ml4ls-demo-unsupervised.share.connect.posit.cloud/](https://olraen-ml4ls-demo-unsupervised.share.connect.posit.cloud/)


## Reproduce the analysis

Render the Quarto analysis from the project directory:

```bash
quarto render analysis.qmd
```

The analysis generates the processed results used by the Shiny application.
Then start the application in R:

```
shiny::runApp()
```

## Files

- `analysis.qmd` — data exploration, preprocessing, PCA and clustering
- `app.R` — Shiny application
- `data/` — clinical and simulated gene-expression data
- `results/clustering_results.rds` — processed results used by the application
- `_quarto.yml` — Quarto project configuration
- `README.md` — project description and instructions
- `renv.lock` — exact R package versions used in the project

## Software

The analysis and application are implemented in **R**.

Main packages include:

- `tidyverse`
- `shiny`
- `quarto`

Package versions are recorded in `renv.lock`.

To restore the project environment:

```r
renv::restore()
```

