# mtcars Plumber API 

## Files

- `cars_api.R` — Plumber API (with route conflict fix: HP filter now at `/cars/filter/hp`)
- `Dockerfile` — Container image for the API
- `render.yaml` — Render.com deployment configuration

## API Endpoints

| Method | Endpoint              | Description                     |
|--------|-----------------------|---------------------------------|
| GET    | `/cars`               | All cars (with limit/offset)    |
| GET    | `/cars/summary`       | Summary statistics              |
| GET    | `/cars/filter/hp`     | Filter by HP range              |
| GET    | `/cars/filter/gear`   | Filter by gear values           |
| GET    | `/cars/<id>`          | Single car by ID                |
| POST   | `/cars`               | Add a new car record            |
| DELETE | `/cars/<id>`          | Delete a car record             |

