# HatoControl · Base de datos

Scripts de la base de datos PostgreSQL de HatoControl. Flyway los aplica en orden; el backend no crea tablas, solo valida que coincidan.

## Estructura

```
migraciones/        V1__crear_tablas.sql
datos-prueba/       V100__datos_finca_la_esperanza.sql
flyway.toml         configuración de Flyway (sin contraseñas)
docker-compose.yml  PostgreSQL 17 local para desarrollo
.env.ejemplo        plantilla de variables; el .env real no se sube
```

## Tablas

`V1__crear_tablas.sql` crea las 8 tablas del diagrama entidad-relación de la Fase 3:

| Tabla | Reglas en la base de datos |
| --- | --- |
| `fincas` | — |
| `usuarios` | correo único en el sistema; rol GANADERO o ADMINISTRADOR |
| `tokens_recuperacion` | solo el hash del token, único; vence y se marca como usado (RNF23) |
| `animales` | arete único dentro de la finca; padrón solo machos y leche solo hembras |
| `partos` | madre obligatoria; las crías apuntan a su parto |
| `registros_sanitarios` | programada exige fecha programada; realizada exige fecha de realización |
| `registros_peso` | peso mayor que cero |
| `registros_leche` | litros mayores que cero; un registro por vaca y día; ligado a un parto |

Las reglas que dependen de la fecha de hoy (fechas no futuras, fecha programada no anterior a hoy) las valida el backend. Los pesos y litros usan `double precision`, igual que `double` en la vista lógica.

## Datos de prueba

`datos-prueba/V100__datos_finca_la_esperanza.sql` carga la finca de los mockups: La Esperanza con 12 animales (Lucero, Canela, Tormenta, Tizón, Paloma…), sus vacunas, pesos, partos y leche, y una segunda finca, Los Rosales, para probar que cada usuario solo ve su finca (HU_022).

| Usuario | Rol | Finca |
| --- | --- | --- |
| jaider@laesperanza.example | Ganadero | La Esperanza |
| camila@laesperanza.example | Administrador | La Esperanza |
| andres@laesperanza.example | Administrador | La Esperanza |
| marta@losrosales.example | Ganadero | Los Rosales |

Todos usan la contraseña de prueba `Esperanza26`. Son datos inventados: nunca se cargan junto con datos reales.

## Seguridad (RNF21)

- En producción la base vive en Amazon RDS, sin acceso público; solo el backend se conecta.
- Ninguna contraseña se guarda en el repositorio: se pasan por variables de entorno.

## Ejecutar en local

```bash
cp .env.ejemplo .env          # y cambia la contraseña
docker compose up -d
FLYWAY_PASSWORD=<la del .env> flyway migrate
# con datos de prueba:
FLYWAY_PASSWORD=<la del .env> flyway -locations=filesystem:migraciones,filesystem:datos-prueba migrate
```
