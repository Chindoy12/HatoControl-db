# HatoControl · Base de datos

Scripts de la base de datos PostgreSQL de HatoControl. Flyway los aplica en orden; el backend no crea tablas, solo valida que coincidan.

## Estructura

```
migraciones/        V1__crear_tablas.sql, V2__… (Fase 8)
datos-prueba/       datos de la finca de ejemplo para pruebas y presentación
flyway.toml         configuración de Flyway (sin contraseñas)
docker-compose.yml  PostgreSQL 17 local para desarrollo
.env.ejemplo        plantilla de variables; el .env real no se sube
```

## Seguridad (RNF21)

- En producción la base vive en Amazon RDS, sin acceso público; solo el backend se conecta.
- Ninguna contraseña se guarda en el repositorio: se pasan por variables de entorno.

## Ejecutar en local

```bash
cp .env.ejemplo .env          # y cambia la contraseña
docker compose up -d
FLYWAY_PASSWORD=<la del .env> flyway migrate
```
