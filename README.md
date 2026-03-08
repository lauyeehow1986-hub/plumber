# mtcars Plumber API — Render.com Deployment

## Files

- `cars_api.R` — Plumber API (with route conflict fix: HP filter now at `/cars/filter/hp`)
- `Dockerfile` — Container image for the API
- `render.yaml` — Render.com deployment configuration

## Deploy to Render.com

### Step 1: Push to GitHub

Create a new GitHub repo and push these three files:

```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git push -u origin main
```

### Step 2: Deploy on Render

1. Go to https://render.com and sign in (GitHub login works)
2. Click **New** → **Web Service**
3. Connect your GitHub repo
4. Render will auto-detect the `Dockerfile`
5. Confirm settings:
   - **Name**: `mtcars-api`
   - **Plan**: Free
   - **Port**: `8000`
6. Click **Create Web Service**

### Step 3: Access your API

After build completes (~5 minutes), your API will be live at:

```
https://mtcars-api.onrender.com
```

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

## Notes

- The free tier spins down after 15 minutes of inactivity. First request after idle takes ~30 seconds.
- Upgrade to the Starter plan ($7/month) for always-on.
- Swagger docs available at `/__docs__/` once deployed.
