FROM python:3.7-slim

WORKDIR /app

COPY app.py .

RUN pip install flask

CMD ["python", "app.py"]
