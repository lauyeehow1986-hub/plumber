FROM rocker/r2u:24.04

RUN apt-get update && apt-get install -y \
    r-cran-plumber \
    r-cran-dplyr \
    r-cran-jsonlite \
    && rm -rf /var/lib/apt/lists/*

RUN R -e "install.packages('swagger', repos = 'https://cloud.r-project.org/')"

RUN R -e "library(plumber); library(dplyr); library(jsonlite); cat('All packages loaded successfully\n')"

COPY cars_api.R /app/cars_api.R

WORKDIR /app

EXPOSE 8000

CMD ["R", "-e", "plumber::pr('/app/cars_api.R') |> plumber::pr_run(host = '0.0.0.0', port = 8000)"]
