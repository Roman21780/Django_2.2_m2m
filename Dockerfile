# Используем официальный образ Python
FROM python:3.13-slim

# Устанавливаем зависимости для Postgres и других системных библиотек
RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    libpq-dev \
    postgresql-client \
    locales \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8

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

# Запускаем Gunicorn (production) будет переопределена в compose при необходимости
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "website.wsgi:application"]