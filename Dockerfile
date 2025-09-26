# Dockerfile (memory-optimized for Render free tier)
FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install minimal system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc g++ \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python packages
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir gunicorn

# Copy app code
COPY . .

# Expose Flask port
EXPOSE 5000

# Run with 2 gunicorn workers (memory-friendly)
CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:5000", "chat:app"]
