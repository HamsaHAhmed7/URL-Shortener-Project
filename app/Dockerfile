#Stage 1: Bulid
FROM python:3.11-alpine AS builder
WORKDIR /app
# hadolint ignore=DL3018
RUN apk add --no-cache gcc musl-dev linux-headers
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

#Stage 2: Run Application
FROM python:3.11-alpine
WORKDIR /app
COPY --from=builder /install /usr/local
COPY src/ .
USER nobody
EXPOSE 8080
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
##