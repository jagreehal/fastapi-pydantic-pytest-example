# Define the base image for the builder stage
FROM python:3.11-slim AS builder

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update \
  && apt-get install --no-install-recommends -y gcc libpq-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Set the working directory in Docker
WORKDIR /app

# Install pipenv
RUN pip install --upgrade pip \
  && pip install pipenv

# Copy the Pipfile and Pipfile.lock into the container
COPY Pipfile Pipfile.lock ./

# Install project dependencies into the root of the project
RUN PIPENV_VENV_IN_PROJECT=1 pipenv install --deploy

# Define the base image for the final stage
FROM python:3.11-slim

# Copy virtual environment from the builder stage
COPY --from=builder /app/.venv /app/.venv

# Set environment path to include the virtual environment
ENV PATH="/app/.venv/bin:$PATH"

# Set the working directory in Docker
WORKDIR /app

# Copy the application code into the container
COPY app app

# Command to run the application
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]
