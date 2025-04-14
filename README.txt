# Integrantes:          
* Alejandro Cáceres [202373520-5] (Paralelo 200)
* Miguel Salamanca [202373564-7] (Paralelo 200)

## Como utilizar

Abrir 'SQL Shell (psql)' o 'pgAdmin 4' y crear una base de datos llamada 'gescon' (si es que no la tienes ya hecha). Esto en SQL Shell se puede hacer de la siguiente forma:

> CREATE DATABASE gescon;           Esto crea la base de datos 'gescon'.
> \c gescon;                        Te conectas a la base de datos.

Con la base de datos ya creada y conectado, hay que hacer algunas cosas antes de poder ejecutar el script que poblara nuestra base de datos.

1. Instalar los modulos necesarios de python:

Para instalar los modulos del script de forma mas sencilla, ejecutar en una terminal (no en SQL Shell):

> pip install -r requirements.txt

2. Configurar .env:

Luego de instalar los modulos, necesitas un archivo llamado '.env', el cual tendra la configuracion de tu base de datos. Este debe verse algo asi:

-------------- .env --------------
DATABASE=gescon
USER=postgres
PASSWORD=admin
HOST=localhost
PORT=1234
----------------------------------

Pero esto solo es un ejemplo. El .env en esta carpeta no tendra esta informacion, solo los nombres de las variables.

3. Poblar la base de datos!

Ya hecho lo anterior, ya puedes ejecutar el script 'DB.py', el cual poblara la base de datos con datos aleatorios con el modulo 'Faker'.

(!) ANTES DE EJECUTAR EL SCRIPT, te recomendamos abrirlo, ya que en este habran variables que puedes modificar para poblar la base de datos a tu gusto. Ademas, tienes la opcion de crear la base de datos desde 0 o no hacerlo. Te recomendamos dejar 'CREAR_DESDE_CERO' en 'True' la primera vez que crees la base de datos, ya que este script tambien crea las tablas de la base de datos. Mas informacion en el script.

Para ejecutar el script, ejecutar en una terminal:

> python DB.py

Si esto no funciona, utilizar:

> python3 DB.py

Si esto no funciona, instala python XD.

Con esto ya creaste y poblaste la base de datos :D! Ya puedes hacer lo que tengas que hacer con ella.
* Las tablas estan en 'CREATE.sql' y es como el script crea las tablas (cargando el mismo archivo).
* Los querys estan en el archivo 'QUERYS.sql'.
* El modelo y diccionario estan en 'MODELO_ER_Y_DICCIONARIO_DE_DATOS.pdf'

## Requerimientos

Para esto utilizamos:
* Python [3.13.0]
* PostgreSQL [17.4]