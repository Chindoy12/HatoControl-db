# Migraciones

Scripts SQL que crean y cambian las tablas. Flyway los aplica en orden y no repite los ya aplicados.

- Nombre: `V<número>__<descripcion>.sql`, por ejemplo `V1__crear_tablas.sql`.
- Un script aplicado no se edita: cada cambio va en un script nuevo con el número siguiente.
- Las tablas siguen el diagrama entidad-relación de la Fase 3.
