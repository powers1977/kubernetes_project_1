# Use official Python image with a slimmed-down base
FROM python:3.11-slim

# Set the working directory inside the container
WORKDIR /app

# Copy only what's needed
COPY app/ ./app/
COPY requirements.txt .

# Install required Python packages
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port Flask will run on
EXPOSE 5000

# Run the Flask app
CMD ["python", "app/main.py"]

