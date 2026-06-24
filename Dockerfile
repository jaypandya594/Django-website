FROM python:3.7-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir \
    Django==2.2.4 \
    django-allauth==0.40.0 \
    django-crispy-forms==1.7.2 \
    django-countries==5.5 \
    stripe==2.37.1 \
    Pillow

COPY . .

EXPOSE 4000

CMD ["python", "manage.py", "runserver", "0.0.0.0:4000"]
