# cars_api.R
# Plumber REST API for mtcars Dataset
# Run with: plumber::pr("cars_api.R") |> plumber::pr_run(port = 8000)

library(plumber)
library(dplyr)
library(jsonlite)

# ── Load data once at startup ──────────────────────────────────────────────────
# Option A: Use R's built-in cars dataset

mtcars_with_model <- mtcars %>%
  mutate(model = rownames(mtcars)) %>%
  relocate(model)

# remove row names
rownames(mtcars_with_model) <- NULL


cars_data <- as.data.frame(mtcars_with_model)
cars_data$id <- seq_len(nrow(mtcars_with_model))

# Option B: Load from your own CSV (uncomment and edit path)
# cars_data <- read.csv("cars.csv")
# cars_data$id <- seq_len(nrow(cars_data))

#* @apiTitle mtcars Data API
#* @apiDescription REST API to query and explore the mtcars dataset
#* @apiVersion 1.0.0

# ── GET all cars ───────────────────────────────────────────────────────────────
#* Get all cars records
#* @param limit Maximum number of records to return (default: 50)
#* @param offset Number of records to skip (default: 0)
#* @get /cars
function(limit = 50, offset = 0) {
  limit <- as.integer(limit)
  offset <- as.integer(offset)

  result <- cars_data %>%
    slice((offset + 1):min(offset + limit, nrow(cars_data)))

  list(
    total = nrow(cars_data),
    limit = limit,
    offset = offset,
    count = nrow(result),
    data = result
  )
}


# ── GET summary statistics ─────────────────────────────────────────────────────
#* Get summary statistics for the dataset
#* @get /cars/summary
function() {
  list(
    total_records = nrow(cars_data),
    mpg = list(
      min = min(cars_data$mpg),
      max = max(cars_data$mpg),
      mean = round(mean(cars_data$mpg), 2),
      median = median(cars_data$mpg)
    ),
    cyl = list(
      min = min(cars_data$cyl),
      max = max(cars_data$cyl),
      mean = round(mean(cars_data$cyl), 2),
      median = median(cars_data$cyl)
    ),
    disp = list(
      min = min(cars_data$disp),
      max = max(cars_data$disp),
      mean = round(mean(cars_data$disp), 2),
      median = median(cars_data$disp)
    ),
    hp = list(
      min = min(cars_data$hp),
      max = max(cars_data$hp),
      mean = round(mean(cars_data$hp), 2),
      median = median(cars_data$hp)
    ),
    drat = list(
      min = min(cars_data$drat),
      max = max(cars_data$drat),
      mean = round(mean(cars_data$drat), 2),
      median = median(cars_data$drat)
    ),
    wt = list(
      min = min(cars_data$wt),
      max = max(cars_data$wt),
      mean = round(mean(cars_data$wt), 2),
      median = median(cars_data$wt)
    ),
    qsec = list(
      min = min(cars_data$qsec),
      max = max(cars_data$qsec),
      mean = round(mean(cars_data$qsec), 2),
      median = median(cars_data$qsec)
    ),
    vs = list(
      min = min(cars_data$vs),
      max = max(cars_data$vs),
      mean = round(mean(cars_data$vs), 2),
      median = median(cars_data$vs)
    ),
    am = list(
      min = min(cars_data$am),
      max = max(cars_data$am),
      mean = round(mean(cars_data$am), 2),
      median = median(cars_data$am)
    ),
    gear = list(
      min = min(cars_data$gear),
      max = max(cars_data$gear),
      mean = round(mean(cars_data$gear), 2),
      median = median(cars_data$gear)
    ),
    carb = list(
      min = min(cars_data$carb),
      max = max(cars_data$carb),
      mean = round(mean(cars_data$carb), 2),
      median = median(cars_data$carb)
    )
  )
}


# ── GET filter by horsepower ────────────────────────────────────────────────────────
#* Filter cars by horsepower range
#* @param min_hp Minimum horsepower (default: 0)
#* @param max_hp Maximum horsepower (default: 999)
#* @get /cars/filter/hp
function(min_hp = 0, max_hp = 999) {
  min_hp <- as.numeric(min_hp)
  max_hp <- as.numeric(max_hp)

  result <- cars_data %>%
    filter(hp >= min_hp, hp <= max_hp)

  list(
    filters = list(min_hp = min_hp, max_hp = max_hp),
    count = nrow(result),
    data = result
  )
}

# ── GET filter by gear ────────────────────────────────────────────────────────
#* Filter cars by number of gears
#* @param gears Comma-separated gear values (e.g., 3,4)
#* @get /cars/filter/gear
function(gears = "") {
  if (gears == "") {
    return(list(
      filters = list(gears = "all"),
      count = nrow(cars_data),
      data = cars_data
    ))
  }

  gear_values <- as.numeric(unlist(strsplit(gears, ",")))

  result <- cars_data %>%
    filter(gear %in% gear_values)

  list(
    filters = list(gears = gear_values),
    count = nrow(result),
    data = result
  )
}


# ── GET single car by ID ───────────────────────────────────────────────────────
#* Get a single record by ID
#* @param id Record ID
#* @get /cars/<id>
function(id) {
  id <- as.integer(id)
  row <- cars_data[cars_data$id == id, ]

  if (nrow(row) == 0) {
    stop(paste("Record with id", id, "not found"))
  }

  row
}


# ── POST add a new car record ──────────────────────────────────────────────────
#* Add a new car record
#* @param model Car Model
#* @param mpg Miles per gallons value
#* @param cyl Number of cylinders in the engine
#* @param disp Engine displacement in cubic inches
#* @param hp Gross horsepower
#* @param drat Rear axle ratio (driveshaft performance)
#* @param wt Weight of the car (in 1000 lbs)
#* @param qsec 1/4 mile time (acceleration performance in seconds)
#* @param vs Engine type (0 = V-shaped, 1 = straight)
#* @param am Transmission type (0 = automatic, 1 = manual)
#* @param gear Number of forward gears
#* @param carb Number of carburetors
#* @post /cars
function(model, mpg, cyl, disp, hp, drat, wt, qsec, vs, am, gear, carb) {
  model <- as.character(model)
  mpg <- as.numeric(mpg)
  cyl <- as.numeric(cyl)
  disp <- as.numeric(disp)
  hp <- as.numeric(hp)
  drat <- as.numeric(drat)
  wt <- as.numeric(wt)
  qsec <- as.numeric(qsec)
  vs <- as.numeric(vs)
  am <- as.numeric(am)
  gear <- as.numeric(gear)
  carb <- as.numeric(carb)
  new_id <- max(cars_data$id) + 1
  new_row <- data.frame(
    model = model,
    mpg = mpg,
    cyl = cyl,
    disp = disp,
    hp = hp,
    drat = drat,
    wt = wt,
    qsec = qsec,
    vs = vs,
    am = am,
    gear = gear,
    carb = carb,
    id = new_id
  )

  cars_data <- bind_rows(cars_data, new_row)

  list(message = "Record added successfully", record = new_row)
}

# ── DELETE a car record ────────────────────────────────────────────────────────
#* Delete a car record by ID
#* @param id Record ID to delete
#* @delete /cars/<id>
function(id) {
  id <- as.integer(id)

  if (!id %in% cars_data$id) {
    stop(paste("Record with id", id, "not found"))
  }

  cars_data <- cars_data[cars_data$id != id, ]

  list(message = paste("Record", id, "deleted successfully"))
}

# ── Auto-export openapi.json + generate swagger docs on startup ────────────────
#* @plumber
function(pr) {
  # Error handler
  pr <- pr %>%
    pr_set_error(function(req, res, err) {
      res$status <- 400
      list(error = conditionMessage(err))
    })

  # Export openapi.json to current working directory
  spec <- pr$getApiSpec()
  jsonlite::write_json(spec, "openapi.json", pretty = TRUE, auto_unbox = TRUE)
  message("✔ openapi.json exported to: ", normalizePath("openapi.json"))

  # Generate swagger HTML using the swagger package (works offline)
  if (requireNamespace("swagger", quietly = TRUE)) {
    swagger_path <- swagger::swagger_path() # path to bundled Swagger UI assets

    html_content <- sprintf(
      '<!DOCTYPE html>
<html>
<head>
  <title>Cars API Docs</title>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="%s/swagger-ui.css">
</head>
<body>
  <div id="swagger-ui"></div>
  <script src="%s/swagger-ui-bundle.js"></script>
  <script src="%s/swagger-ui-standalone-preset.js"></script>
  <script>
    SwaggerUIBundle({
      url: "./openapi.json",
      dom_id: "#swagger-ui",
      presets: [
        SwaggerUIBundle.presets.apis,
        SwaggerUIStandalonePreset
      ],
      layout: "StandaloneLayout",
      deepLinking: true,
      displayRequestDuration: true,
      filter: true
    })
  </script>
</body>
</html>',
      swagger_path,
      swagger_path,
      swagger_path
    )

    writeLines(html_content, "swagger.html")
    message("✔ swagger.html generated at: ", normalizePath("swagger.html"))
  } else {
    message(
      "ℹ Install the swagger package for offline docs: install.packages('swagger')"
    )
  }

  pr
}
