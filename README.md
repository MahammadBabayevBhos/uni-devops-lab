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

## Serverə quraşdırma (Ansible)

```
ansible/
  ansible.cfg                 SSH və inventory ayarları
  inventory.ini               app server (IP, istifadəçi)
  group_vars/app_servers.yml  port, image adı, qovluq yolu və s.
  playbook.yml
  templates/env.j2            Compose üçün .env (port və image adı)
```

Control node-da public key app server-dəki istifadəçinin `authorized_keys` faylına əlavə olunur, qoşulma şifrəsiz SSH ilə gedir. Private key repository-də saxlanılmır.

```bash
cd ansible
ansible app_servers -m ping
ansible-playbook playbook.yml
```

Playbook ardıcıllıqla:

1. Docker-in rəsmi apt repository-sini əlavə edir, Docker Engine və Compose plugin-i quraşdırır, `docker` servisini aktiv edir.
2. `Dockerfile`, `.dockerignore`, `compose.yml` və `app/` fayllarını `app_dir` qovluğuna köçürür, dəyişənlərdən `.env` yaradır.
3. `docker compose up` edir. Fayllar dəyişibsə image yenidən yığılır, dəyişməyibsə mövcud image istifadə olunur.
4. `http://<server-ip>:<port>/health` cavabını yoxlayıb ekrana çıxarır.

Bütün task-lar idempotentdir, ikinci icrada `changed=0` olur.
