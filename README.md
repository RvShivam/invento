# 📦 Invento Backend

A robust backend system for **Invento**, built using **Django REST Framework** and **PostgreSQL**.
It provides secure authentication with JWT, modular API endpoints, and scalable design suitable for production deployment.

---

## 🚀 Features

* RESTful APIs built on **Django REST Framework (DRF)**
* **JWT-based authentication**
* **PostgreSQL** as the database
* **CORS** enabled for frontend integration
* Custom **User model** and **Email-based login**
* Production-ready structure with environment-based configuration

---

## 🔧 Tech Stack

| Component         | Technology            |
| ----------------- | --------------------- |
| Backend Framework | Django 5.2.5          |
| API Framework     | Django REST Framework |
| Authentication    | JWT (SimpleJWT)       |
| Database          | PostgreSQL            |
| Email             | SendGrid (optional)   |
| Language          | Python 3.10+          |

---

## 📁 Project Structure

```
invento_backend/
│
├── api/                     # Core app with API logic
│   ├── models.py            # Database models
│   ├── views.py             # API views
│   ├── serializers.py       # DRF serializers
│   ├── urls.py              # API route definitions
│   └── backends.py          # Custom authentication backend
│
├── invento_backend/
│   ├── settings.py          # Project configuration
│   ├── urls.py              # Root URL configuration
│   └── wsgi.py              # WSGI entry point
│
├── manage.py                # Django management CLI
└── requirements.txt         # Project dependencies
```

---

## ⚙️ Environment Setup

### 1. Clone the Repository

```bash
git clone https://github.com/RvShivam/invento.git
cd invento/invento_backend
```

### 2. Create and Activate Virtual Environment

```bash
python -m venv venv
source venv/bin/activate    # macOS / Linux
venv\Scripts\activate       # Windows
```

### 3. Install Dependencies

```bash
pip install -r requirements.txt
```

---

## 🗄️ Database Configuration

### 1. Install PostgreSQL

Ensure PostgreSQL is installed and running.
You can download it from [postgresql.org/download](https://www.postgresql.org/download/).

### 2. Create Database and User

In the PostgreSQL shell:

```sql
CREATE DATABASE invento_db;
CREATE USER invento_user WITH PASSWORD 'invento@1234';
ALTER ROLE invento_user SET client_encoding TO 'utf8';
ALTER ROLE invento_user SET default_transaction_isolation TO 'read committed';
ALTER ROLE invento_user SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE invento_db TO invento_user;
```

---

## 🔐 Environment Variables

Before running the project, configure the following environment variables in a `.env` file (or export them in your environment):

```
# Django settings
SECRET_KEY=your_secret_key_here
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1

# Database
DB_NAME=invento_db
DB_USER=invento_user
DB_PASSWORD=invento@1234
DB_HOST=localhost
DB_PORT=5432

# Email (SendGrid)
EMAIL_BACKEND=django.core.mail.backends.smtp.EmailBackend
EMAIL_HOST=smtp.sendgrid.net
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=apikey
EMAIL_HOST_PASSWORD=your_sendgrid_api_key
DEFAULT_FROM_EMAIL=your_verified_sender@example.com
```

> ⚠️ **Note:** Never commit `.env` or credentials to GitHub.

---

## 🧮 Migrations & Database Setup

Apply migrations to initialize your database schema:

```bash
python manage.py makemigrations
python manage.py migrate
```

You can optionally create a superuser:

```bash
python manage.py createsuperuser
```

---

## ▶️ Running the Server

Start the local development server:

```bash
python manage.py runserver
```

The backend will be live at:
**[http://127.0.0.1:8000/](http://127.0.0.1:8000/)**

API endpoints are available under:
**[http://127.0.0.1:8000/api/](http://127.0.0.1:8000/api/)**

---

## 🌐 CORS Configuration

By default, CORS allows all localhost origins for frontend integration.
If deploying, update this section in `settings.py`:

```python
CORS_ALLOWED_ORIGIN_REGEXES = [
    r"^https://your-frontend-domain\.com$",
]
```

---

## 🗾 JWT Authentication

Invento uses JWT for secure user authentication.
Example token endpoints (once backend is running):

| Method | Endpoint              | Description                        |
| ------ | --------------------- | ---------------------------------- |
| POST   | `/api/token/`         | Obtain JWT access + refresh tokens |
| POST   | `/api/token/refresh/` | Refresh the access token           |

---

## 📤 Deployment Notes

For production deployment:

1. Set `DEBUG = False` in `settings.py`
2. Add your server domain to `ALLOWED_HOSTS`
3. Configure a production database and update credentials
4. Use a WSGI/ASGI server like **Gunicorn** or **Uvicorn**
5. Serve static files with **WhiteNoise** or a reverse proxy (e.g., Nginx)

---

## 🤓 Development Notes

* The backend uses a **custom user model (`api.User`)**
* Authentication uses **email instead of username**
* REST authentication is handled by `rest_framework_simplejwt`
* CORS enabled for local frontend testing

---
