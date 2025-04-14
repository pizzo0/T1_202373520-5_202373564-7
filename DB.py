from dotenv import load_dotenv
from faker import Faker
import psycopg2
import random
from time import time
from os import getenv

load_dotenv() # Debe haber un .env con las variables de abajo.

DATABASE = getenv('DATABASE')
USER = getenv('USER')
PASSWORD = getenv('PASSWORD')
HOST = getenv('HOST')
PORT = getenv('PORT')

# Esta funcion solo crea ruts que sean mas creibles para la bdd.
def generar_rut():
    dv = random.randint(0,10)
    return f'{random.randint(8,21)}.{random.randint(100,999)}.{random.randint(100,999)}-{'K' if dv == 10 else str(dv)}'

coneccion = psycopg2.connect(
    database=DATABASE,
    user=USER,
    password=PASSWORD,
    host=HOST,
    port=PORT
)

faker = Faker('es_CL')
db = coneccion.cursor()

# Constantes por si quieres modificar como se pobla la base de datos:
NUM_USUARIOS = 300
NUM_TOPICOS = 30                        # numero de topicos que existiran en la base de datos
NUM_MAX_ESPECIALIDADES = 2              # es el numero maximo que un usuario puede tener de especialidades, pudiendo ser entre 0 y el numero que ingreses aqui. basicamente, si no tiene especialidad, es solo un autor y no puede ser un revisor
NUM_MAX_AUTORES = 5                     # es el numero maximo de autores que puede tener un articulo, pudiendo ser entre 1 y el numero que ingreses aqui
NUM_MAX_TOPICOS = 3                     # es el numero maximo de topicos que puede tener un articulo escogidos de forma aleatoria sin repetirse, pudiendo ser entre 1 y el numero que ingreses aqui
NUM_MAX_REVISORES = 3                   # es el numero maximo de revisores que puede tener un articulo. Siempre se intentara tener el maximo (por defecto [y por lo que pide la tarea] seran 3), pero en caso de no haber mas revisores disponibles, se dejan los revisores que se alcance a asignar en el MAX_TIEMPO que se asigne.
MAX_TIEMPO = 3                          # es el maximo tiempo (en segundos) que puede tardarse el algoritmo en seleccionar a los revisores para un articulo. esto es mas que nada para que el algoritmo no quede en un bucle infinito.

# SI QUIERES QUE LA BASE DE DATOS SE CREE POR SI SOLA, DEJAR EN **True**.
# SI QUIERES QUE LA BASE DE DATOS SE CREE DESDE CERO, YA TENIENDO LA BASE DE DATOS POBLADA, DEJAR EN **True**. -> ESTO BORRA TODAS LAS TABLAS
# SI SOLO QUIERES POBLAR MAS LA BASE DE DATOS CON INFORMACION ALEATORIA, DEJAR EN **False**. -> ESTO NO BORRA NADA!
CREAR_DESDE_CERO = True         

if CREAR_DESDE_CERO:
    db.execute("DROP TABLE IF EXISTS Articulos_Revisores,Articulos_Autores,Articulos_Topicos,Usuarios_Especialidades,Articulos,Topicos,Usuarios CASCADE;")
    with open("CREATE.sql",'r') as archivo:
        db.execute(archivo.read())


# USUARIOS
print('CREANDO USUARIOS')
usuarios = [] # (rut,nombre,email)
for _ in range(NUM_USUARIOS):
    rut = generar_rut()
    nombre = faker.name()
    email = faker.unique.email()
    usuarios.append((rut,nombre,email))
    
    db.execute('INSERT INTO Usuarios (rut,nombre,email) VALUES (%s,%s,%s)', (rut, nombre, email))

# TOPICOS
print('CREANDO TOPICOS')
topicos = [] #(id,nombre)
for _ in range(NUM_TOPICOS):
    nombre = faker.unique.job()
    
    db.execute('INSERT INTO Topicos (nombre) VALUES (%s) RETURNING id', (nombre,))
    id = db.fetchone()[0]
    
    topicos.append((id,nombre))

# REVISORES -> Se asignan especialidades a algunos usuarios, de forma que sean revisores
print('ASIGNANDO ESPECIALIDADES (REVISORES)')
usuarios_especialidades = [] #(rut,[esp_1,esp_2,...])
for rut,_,_ in usuarios:
    especialidades = set()
    
    for _ in range(random.randint(0,NUM_MAX_ESPECIALIDADES)):
        rand_especialidad = random.choice(topicos)[0]
        if rand_especialidad not in especialidades:
            db.execute("INSERT INTO Usuarios_Especialidades (rut_usuario,id_topico) VALUES (%s,%s)", (rut,rand_especialidad))
            especialidades.add(rand_especialidad)
    
    usuarios_especialidades.append((rut,especialidades))

# ARTICULOS -> Se crean articulos, asignando autores, autor de contacto, revisores y topicos. Si en 3 segundos no se encuentran los 3 revisores, se dejan los que logro asignar. Si un artculo no logra encontrar los suficientes revisores, en la terminal se printea ('skip...'), por lo que si esto ocurre, ya sabes que habra articulos con menos de 3 revisores. Mientras mas grande la poblacion, mas dificil es que este skipeo ocurra.
print('CREANDO ARTICULOS (ESTE TARDA MAS)')
for _ in range(1000):
    titulo = faker.sentence(nb_words=6)
    resumen = faker.text(max_nb_chars=150)
    
    autores_articulo = random.sample(usuarios, random.randint(1,NUM_MAX_AUTORES))
    rut_contacto = random.choice(autores_articulo)[0]
    
    topicos_articulo = random.sample(topicos, random.randint(1,NUM_MAX_TOPICOS))
    
    db.execute("INSERT INTO Articulos (titulo,resumen,rut_contacto) VALUES (%s,%s,%s) RETURNING id", (titulo,resumen,rut_contacto))
    id_articulo = db.fetchone()[0]
    
    # TOPICOS ALEATORIOS
    for id_topico,_ in topicos_articulo:
        db.execute("INSERT INTO Articulos_Topicos (id_articulo,id_topico) VALUES (%s,%s)", (id_articulo,id_topico))
    
    # AUTORES ALEATORIOS
    for rut,_,_ in autores_articulo:
        db.execute("INSERT INTO Articulos_Autores (id_articulo,rut_autor) VALUES (%s,%s)", (id_articulo,rut))
    
    # REVISORES ALEATORIOS (MAX. 3 POR DEFECTO)
    revisores_articulo = []
    inicio = time()
    while len(revisores_articulo) < NUM_MAX_REVISORES:
        if time()-inicio > MAX_TIEMPO:
            print("skip...")
            break
        
        revisor = random.choice(usuarios)
        
        if revisor[0] in [autor[0] for autor in autores_articulo] or revisor[0] in [revisor_articulo[0] for revisor_articulo in revisores_articulo]:
            continue
        
        db.execute("SELECT id_topico FROM Usuarios_Especialidades WHERE rut_usuario=%s", (revisor[0],))
        especialidades_revisor = [esp_revisor[0] for esp_revisor in db.fetchall()]
        
        if any(esp_revisor in [topico_id for topico_id, _ in topicos_articulo] for esp_revisor in especialidades_revisor):
            db.execute("INSERT INTO Articulos_Revisores (id_articulo,rut_revisor) VALUES (%s,%s)", (id_articulo, revisor[0]))
            revisores_articulo.append(revisor)

print('LISTO :)')
coneccion.commit()

db.close()
coneccion.close()