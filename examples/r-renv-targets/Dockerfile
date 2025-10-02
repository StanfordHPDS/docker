FROM stanfordhpds/r-renv:latest

# Copy project files - this triggers the ONBUILD instructions
# which will:
# 1. Copy renv.lock, renv/activate.R, .Rprofile
# 2. Install the R version specified in renv.lock
# 3. Restore all packages
# 4. Copy the rest of the project files
COPY . .

# The working directory is already set to /project
# renv will be automatically activated when R starts

# Run the pipeline by default
CMD ["R", "-e", "targets::tar_make()"]