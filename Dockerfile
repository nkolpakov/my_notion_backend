# Используем Alpine-based Python образ
FROM python:3.13-alpine

# Устанавливаем переменные окружения
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PIP_DISABLE_PIP_VERSION_CHECK 1

# Устанавливаем зависимости для psycopg2
RUN apk update && \
    apk add --no-cache \
    python3-dev && pip install --upgrade pip && \
    pip install poetry && pip install setuptools
# Создаем и переходим в рабочую директорию
WORKDIR /app

# Копируем файлы зависимостей
COPY pyproject.toml poetry.lock* /app/

# Устанавливаем зависимости проекта
RUN poetry config virtualenvs.create false && \
    poetry install --no-root --no-interaction --no-ansi --only main

# Копируем остальные файлы проекта
COPY . /app/

# Открываем порт
EXPOSE 8000

# Команда для запуска (измените под свой проект)
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]