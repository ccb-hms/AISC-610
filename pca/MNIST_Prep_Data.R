# Install dslabs if you don't have it
if(!require(dslabs)) install.packages("dslabs")

# Download the official MNIST dataset
cat("Downloading MNIST data...\n")
mnist <- dslabs::read_mnist()

# Take a 2,000 image sample to keep the Shiny app fast
set.seed(42)
idx <- sample(1:nrow(mnist$test$images), 2000)

digits_X <- mnist$test$images[idx, ] / 255 # Scale pixels to 0-1
digits_y <- mnist$test$labels[idx]

# Save as an RDS file in your pca folder
saveRDS(list(X = digits_X, y = digits_y), "mnist_prepared.rds")
cat("Done! Saved as mnist_prepared.rds\n")