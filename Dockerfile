# Dockerfile - minimal production-ready Flask image
FROM python:3.11-slim

# Set a non-root user (optional but recommended)
ARG APP_USER=app
RUN groupadd -r ${APP_USER} && useradd -r -g ${APP_USER} ${APP_USER}

WORKDIR /app

# install system deps needed for many python packages (adjust if not required)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libssl-dev \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# copy requirements first to leverage docker cache
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# copy application source
COPY . /app

# ensure owned by non-root user
RUN chown -R ${APP_USER}:${APP_USER} /app

USER ${APP_USER}

# expose port used by your flask app (5000 default)
EXPOSE 5000

# final command — set to how you run Flask in prod (gunicorn recommended)
# If you use plain flask: FLASK_APP=app.py flask run --host=0.0.0.0 --port=5000
# Below uses gunicorn (install in requirements.txt)
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app", "--workers", "3", "--threads", "2"]

