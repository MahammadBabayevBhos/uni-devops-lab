FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Asılılıqlar ayrıca layer-də: kod dəyişəndə pip install təkrarlanmır
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ .

RUN useradd --system --uid 10001 portal
USER portal

EXPOSE 5000

CMD ["python", "app.py"]
