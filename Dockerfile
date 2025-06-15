# Используем официальный образ Python
FROM python:3.13-slim

# Устанавливаем зависимости для Postgres и других системных библиотек
RUN apt-get update && apt-get install -y \
    curl \
    postgresql-client \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Создаем и переходим в рабочую директорию
WORKDIR /app

# Копируем только requirements.txt сначала для кэширования слоев
COPY requirements.txt .

# Устанавливаем зависимости Python
RUN pip install --no-cache-dir -r requirements.txt

# Копируем остальные файлы проекта
COPY . .

# Собираем статику (если нужно)
RUN python manage.py collectstatic --noinput

# Указываем порт, который будет использоваться
EXPOSE 8000

# Запускаем Gunicorn (production)
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--access-logfile", "-", "website.wsgi"]
