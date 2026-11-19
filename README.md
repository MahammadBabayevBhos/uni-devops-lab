# uni-devops-lab

Universitet tələbə portalının Git, Docker və Ansible ilə idarə olunması və serverə avtomatik qurulması üzrə praktiki layihə.

## Struktur

```
app/        Flask tətbiqi (app.py) və asılılıqlar (requirements.txt)
ansible/    Serverə quraşdırma üçün inventory və playbook
Dockerfile  Portal image-i (python:3.12-slim)
compose.yml Portal + Redis
```

## Lokal işə salma

```bash
docker build -t student-portal:1.0 .
docker compose up -d
curl http://localhost:8080/health
curl http://localhost:8080/visits
```

Portal konteynerdə 5000 portunda işləyir, xaricə 8080 portu ilə açılır. Redis-ə `redis` servis adı ilə qoşulur (`REDIS_HOST`). Redis datası `redis-data` named volume-da saxlanılır, ona görə `docker compose restart` və ya `down`/`up`-dan sonra `/visits` sayı sıfırlanmır.

Port və image adı `PORTAL_PORT` və `PORTAL_IMAGE` dəyişənləri ilə dəyişdirilə bilər (default: `8080`, `student-portal:1.0`).
