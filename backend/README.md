# ARTEPIX Backend

This directory contains the FastAPI backend for the ARTEPIX Smart Packaging App, containerized with Docker.

## Directory Structure
```
backend/
├── app/
│   ├── api/        # Route handlers
│   ├── core/       # Config & Security
│   ├── db/         # Database connections
│   ├── models/     # SQLAlchemy Models
│   ├── schemas/    # Pydantic Schemas
│   └── main.py     # Entry point
├── docker-compose.yml
├── Dockerfile
├── requirements.txt
└── deploy.sh       # VPS Deployment Script
```

## Deployment Instructions (VPS)

1. **Upload the Code**
   Upload this entire `backend` folder to your VPS (e.g., using `scp` or FileZilla).
   ```bash
   scp -r backend root@72.61.215.223:/root/artepix-backend
   ```

2. **Run Deployment Script**
   SSH into your VPS and run the deploy script.
   ```bash
   ssh root@72.61.215.223
   cd /root/artepix-backend
   chmod +x deploy.sh
   ./deploy.sh
   ```

3. **Verify Deployment**
   After the script completes, check if the services are running:
   ```bash
   docker compose ps
   ```
   You should see `web`, `db`, and `mongo` running.

4. **Access API**
   Your API will be available at: `http://72.61.215.223:8000`
   - Swagger UI: `http://72.61.215.223:8000/docs`
   - Health Check: `http://72.61.215.223:8000/health`

## Local Development
To run locally:
```bash
docker-compose up --build
```
