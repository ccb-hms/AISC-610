# AISC 610: Computationally-Enabled Medicine

Supplementary interactive notes and computational simulations for **AISC 610** at Harvard Medical School. 

## Overview
This repository contains interactive Quarto documents (powered by R and Shiny) designed to bridge statistical theory with clinical data science. The modules allow students to physically interact with the math underlying modern medical literature and algorithms.

## Contents
* **[`p-values`](https://ccb.connect.hms.harvard.edu/AISC-610-p-values/)**: Notes on the $p$-value. Explores the inverse probability fallacy, the illusion of certainty via sample size, and confounding by indication.
* **[`neural-nets`](https://ccb.connect.hms.harvard.edu/AISC-610-neural-nets/)**: Notes on logistic regression. Provides a visual breakdown of how classical logistic regression scales into deep neural networks to capture complex, non-linear patterns in data.
* **[`pca`](https://ccb.connect.hms.harvard.edu/AISC-610-pca/)**: Notes on principal component analysis. Provides the geometrical and mathematical intuition of PCA and provides examples.

## Usage
These modules are designed to be deployed as interactive web applications via Posit Connect for student access. 

To run them locally:
1. Clone this repository.
2. Open the `.qmd` files in Positron or RStudio.
3. Ensure you have the required R packages installed (`shiny`, `ggplot2`, `neuralnet`, etc.).
4. Click **Run Document**.