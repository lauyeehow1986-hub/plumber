FROM rocker/r-ver:4.4.0

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install packages separately so failures are clear
RUN R -e "install.packages('plumber', repos = 'https://cloud.r-project.org/')"
RUN R -e "install.packages('dplyr', repos = 'https://cloud.r-project.org/')"
RUN R -e "install.packages('jsonlite', repos = 'https://cloud.r-project.org/')"FROM rocker/r-ver:4.4.0

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install packages and verify they're installed
RUN R -e "install.packages('plumber', repos = 'https://cloud.r-project.org/')" && \
    R -e "if (!requireNamespace('plumber', quietly = TRUE)) stop('plumber failed to install')"

RUN R -e "install.packages('dplyr', repos = 'https://cloud.r-project.org/')" && \
    R -e "if (!requireNamespace('dplyr', quietly = TRUE)) stop('dplyr failed to install')"

RUN R -e "install.packages('jsonlite', repos = 'https://cloud.r-project.org/')" && \
    R -e "if (!requireNamespace('jsonlite', quietly = TRUE)) stop('jsonlite failed to install')"

RUN R -e "install.packages('swagger', repos = 'https://cloud.r-project.org/')" && \
    R -e "if (!requireNamespace('swagger', quietly = TRUE)) stop('swagger failed to install')"

# Verify all packages one final time
RUN R -e "library(plumber); library(dplyr); library(jsonlite); library(swagger); cat('All packages loaded successfully\n')"

COPY cars_api.R /app/cars_api.R

WORKDIR /app

EXPOSE 8000

CMD ["R", "-e", "plumber::pr('/app/cars_api.R') |> plumber::pr_run(host = '0.0.0.0', port = 8000)"]
RUN R -e "install.packages('swagger', repos = 'https://cloud.r-project.org/')"

COPY cars_api.R /app/cars_api.R

WORKDIR /app

EXPOSE 8000

CMD ["R", "-e", "plumber::pr('/app/cars_api.R') |> plumber::pr_run(host = '0.0.0.0', port = 8000)"]
