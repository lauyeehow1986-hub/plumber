FROM rocker/r-ver:4.4.0

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install R packages
RUN R -e "install.packages(c('plumber', 'dplyr', 'jsonlite', 'swagger'), repos = 'https://cloud.r-project.org/')"

# Copy API file
COPY cars_api.R /app/cars_api.R

WORKDIR /app

EXPOSE 8000

CMD ["R", "-e", "plumber::pr('/app/cars_api.R') |> plumber::pr_run(host = '0.0.0.0', port = 8000)"]
