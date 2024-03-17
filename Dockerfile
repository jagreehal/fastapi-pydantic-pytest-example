# Use a specific version of the Python slim image for consistent builds
FROM python:3.11.1-slim AS builder

# Prevent Python from writing pyc files to disc and buffering stdout and stderr
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install system dependencies required for building Python packages
RUN apt-get update && apt-get install --no-install-recommends -y \
    gcc \
    libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Upgrade pip and install pipenv
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir pipenv

# Install project dependencies using Pipfile and Pipfile.lock
COPY Pipfile Pipfile.lock ./
RUN PIPENV_VENV_IN_PROJECT=1 pipenv install --deploy

# Start a new stage from a slim version of the Python image
FROM python:3.11.1-slim

# Copy the virtual environment from the builder stage
COPY --from=builder /app/.venv /app/.venv

# Ensure scripts in .venv are usable:
ENV PATH="/app/.venv/bin:$PATH"

WORKDIR /app

# Copy the application code into the container
COPY app app

# Use an environment variable for the application port
ENV PORT=80

# Create a non-root user for running the application
RUN useradd --create-home appuser
USER appuser

# Use the exec form of CMD to ensure signals are properly handled by uvicorn
CMD ["sh", "-c", "uvicorn app.main:app --host 0.0.0.0 --port $PORT"]

