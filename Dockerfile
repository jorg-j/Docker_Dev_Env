FROM python:3.10-slim-buster
ARG VERSION=0.0.1
# Create and activate virtual environment
RUN python -m venv /opt/venv && \
    . /opt/venv/bin/activate && \
    pip install --upgrade pip

# Install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Set working directory
RUN mkdir -p /code
WORKDIR /code/

# Copy source code
COPY . .

# Set environment variable
ENV VERSION=0.0.1