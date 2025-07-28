# Use an official Python runtime as a parent image
#FROM python:3.9-slim-buster

# Set the working directory in the container
#WORKDIR /app

# Copy the current directory contents into the container at /app
#COPY . /app

# Install any needed packages specified in requirements.txt
#RUN pip install --no-cache-dir -r requirements.txt

# Make port 5000 available to the world outside this container
#EXPOSE 5000

# Run app.py when the container launches
#CMD ["python", "app.py"]

# Use an official Python runtime as a parent image
FROM python:3.9-slim-buster

# Set the working directory in the container
WORKDIR /app

# Copy only the requirements.txt first to leverage Docker's build cache
# Your requirements.txt is in 'app/' on the host, so copy it into /app/ (WORKDIR)
COPY app/requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your application code from the 'app' directory on host
# to the current working directory './' (which is /app) in the container
COPY app/ .

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Run app.py when the container launches
# Assuming app.py is now directly in /app inside the container
CMD ["python", "app.py"]