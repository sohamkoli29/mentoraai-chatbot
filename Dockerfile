# Dockerfile (production, uses gunicorn)
FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system deps (needed for some Python wheels)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Ensure gunicorn is available (you can also add it to requirements.txt)
RUN pip install --no-cache-dir gunicorn

# Download spaCy model so it exists at runtime (avoids runtime failure)
RUN python -m spacy download en_core_web_sm

# Copy app code
COPY . .

# Expose Flask port
EXPOSE 5000

# Use gunicorn for production; expects `app` in chat.py (chat:app)
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "chat:app"]
