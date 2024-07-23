# Periodic Table Lookup Script

Este repositorio contiene un script de Bash y un archivo SQL para crear y consultar una base de datos de la tabla periódica. El script `element.sh` permite buscar elementos por número atómico, símbolo o nombre, mientras que `periodic_table.sql` prepara la base de datos con la información necesaria.

## Prerrequisitos

Antes de ejecutar este script, asegúrate de tener instalado:
- PostgreSQL
- Bash (Linux, macOS o Windows Subsystem for Linux en Windows)

## Configuración de la Base de Datos

1. Inicia el servicio de PostgreSQL.
2. Crea una base de datos llamada `periodic_table`:
   ```sql
   CREATE DATABASE periodic_table;
3. Ejecuta el script `periodic_table.sql` para crear las tablas y llenarlas con datos sobre los elementos:
   ```bash
   psql -U usuario -d periodic_table -a -f periodic_table.sql
   ```
   Reemplaza usuario con tu nombre de `usuario` de PostgreSQL.
## Uso del Script
Para usar el script `element.sh`, navega al directorio que contiene el script y ejecuta:
```bash
./element.sh [argumento]
```
El `[argumento]` puede ser:
+ Un número atómico (por ejemplo, 2 para Helio)
+ Un símbolo (por ejemplo, He para Helio)
+ Un nombre (por ejemplo, Helium)

El script mostrará información detallada sobre el elemento, incluyendo su número atómico, nombre, tipo, masa atómica, punto de fusión y punto de ebullición.
### Ejemplos
```bash
./element.sh 2
```
```bash
./element.sh He
```
```bash
./element.sh Helium
```
