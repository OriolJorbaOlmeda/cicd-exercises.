FROM python:3.11.0a3-alpine3.15
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["demo.py"]