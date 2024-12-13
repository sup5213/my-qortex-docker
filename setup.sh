#!/bin/bash
set -e
echo "Клонирование репозитория..."
mkdir -p ./src
cd ./src
git clone https://github.com/sup5213/my-qortex-test.git
echo "Создание директорий и копирование файлов..."
cp ./my-qortex-test/for_docker/env.conf ./my-qortex-test/.env
mkdir -p ./dbdata
chmod -R 777 ./dbdata
mkdir -p ./apache
chmod -R 777 ./apache
cp ./my-qortex-test/for_docker/000-default.conf ./apache/000-default.conf
cd ..
echo "Сборка образа..."
docker-compose build
echo "Запуск контейнеров..."
docker-compose up -d
echo "Выполнение команд внутри контейнера..."
docker-compose exec app composer install
docker-compose exec app php artisan key:generate
docker-compose exec app php artisan migrate
docker-compose exec app php artisan route:clear
docker-compose exec app php artisan cache:clear
docker-compose exec app php artisan config:clear
docker-compose exec app php artisan config:cache
docker-compose exec app php artisan route:cache
docker-compose exec app chown -R www-data:www-data /var/www/html/my-qortex-test
docker-compose exec app chmod -R 777 /var/www/html/my-qortex-test/storage
docker-compose exec app chmod -R 777 /var/www/html/my-qortex-test
echo "Импорт базы данных..."
cd ./src
cp ./my-qortex-test/database_dump.sql ./dbdata/database_dump.sql
docker-compose exec -T db mysql -u root qortex_test < ./dbdata/database_dump.sql
cd ..
echo "OK"
