library(shiny)
library(tidyverse)

# Load prepared results
results <- readRDS("results/clustering_results.rds")

res_pca <- results$res_pca
gene_cluster_stats <- results$gene_cluster_stats

# Variables to explore
clinical_vars <- c(
  "BMI",
  "chol",
  "stab.glu",
  "hdl",
  "ratio",
  "glyhb",
  "age",
  "height",
  "weight",
  "waist",
  "hip",
  "gender",
  "frame",
  "location",
  "BMI>30"
)

ui <- fluidPage(

  titlePanel("Exploring gene-expression clusters"),

  sidebarLayout(

    sidebarPanel(

      selectInput(
        "variable",
        "Clinical variable:",
        choices = clinical_vars,
        selected = "BMI"
      ),

      selectInput(
        "cluster_gene",
        "Cluster for gene exploration:",
        choices = levels(res_pca$cluster),
        selected = levels(res_pca$cluster)[1]
      )
    ),

    mainPanel(

      h3("Gene-expression clusters"),
      plotOutput("pca_plot"),

      h3("Clinical characteristics"),
      plotOutput("clinical_plot"),

      h3("Genes characterising the clusters"),
      plotOutput("gene_plot")
    )
  )
)

server <- function(input, output, session) {

  # PCA plot
  output$pca_plot <- renderPlot({

    res_pca |>
      ggplot(
        aes(
          x = PC1,
          y = PC2,
          fill = cluster
        )
      ) +
      geom_point(
        shape = 21,
        size = 3,
        alpha = 0.7
      ) +
      theme_bw() +
      labs(
        x = "PC1",
        y = "PC2",
        fill = "Cluster"
      )
  })


  # Clinical variable plot
  output$clinical_plot <- renderPlot({

    variable <- res_pca[[input$variable]]

    if (is.numeric(variable)) {

      # Numerical variables
      res_pca |>
        ggplot(
          aes(
            x = cluster,
            y = .data[[input$variable]],
            color = cluster
          )
        ) +
        geom_jitter(
          width = 0.15,
          alpha = 0.4
        ) +
        geom_boxplot(
          alpha = 0.4,
          outlier.shape = NA
        ) +
        theme_bw() +
        labs(
          x = "Cluster",
          y = input$variable,
          color = "Cluster"
        )

    } else {

      # Categorical variables
      res_pca |>
        filter(!is.na(.data[[input$variable]])) |>
        count(
          cluster,
          category = .data[[input$variable]]
        ) |>
        group_by(cluster) |>
        mutate(
          proportion = n / sum(n)
        ) |>
        ggplot(
          aes(
            x = cluster,
            y = proportion,
            fill = category
          )
        ) +
        geom_col() +
        theme_bw() +
        labs(
          x = "Cluster",
          y = "Proportion",
          fill = input$variable
        )
    }
  })


  # Genes characterising selected cluster
  output$gene_plot <- renderPlot({

    gene_cluster_stats |>
      filter(cluster == input$cluster_gene) |>
      slice_max(
        order_by = abs(difference),
        n = 10
      ) |>
      ggplot(
        aes(
          x = reorder(gene, difference),
          y = difference
        )
      ) +
      geom_col() +
      coord_flip() +
      theme_bw() +
      labs(
        title = paste(
          "Top genes characterising cluster",
          input$cluster_gene
        ),
        x = "",
        y = "Standardised expression difference"
      )
  })
}

shinyApp(ui, server)