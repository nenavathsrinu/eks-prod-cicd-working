FROM python:3.11-slim

RUN pip install boto3

WORKDIR /app
COPY app.py .

CMD ["python", "app.py"]
