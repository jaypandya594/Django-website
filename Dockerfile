
FROM python:3.9-slim

# Install system dependencies required for compiling legacy packages securely
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .

# Upgrade pip and install setuptools fallback first to handle legacy packages (like jsmin/allauth)
RUN pip install --no-cache-dir --upgrade pip setuptools<58.0.0

# Install requirements from your cleaned file + your production servers
RUN pip install --no-cache-dir -r requirements.txt \
    gunicorn \
    whitenoise \
    dj-database-url

COPY . .

# Set a dummy secret key so collectstatic doesn't crash during the Docker build
ENV SECRET_KEY="build-time-dummy-key"
ENV ENVIRONMENT="production"

RUN python manage.py collectstatic --noinput || true

EXPOSE 4000

CMD ["gunicorn", "demo.wsgi:application", "--bind", "0.0.0.0:4000", "--workers", "2"]
