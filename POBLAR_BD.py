from dotenv import load_dotenv
from faker import Faker
import psycopg2
import random
from os import getenv

DATABASE = getenv('DATABASE')
USER = getenv('USER')
PASSWORD = getenv('PASSWORD')
HOST = getenv('HOST')
PORT = getenv("5432")


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

db.execute("DROP TABLE IF EXISTS Articulos_Revisores,Articulos_Autores,Articulos_Topicos,Usuarios_Especialidades,Articulos,Topicos,Usuarios CASCADE;")

with open("CREATE.sql",'r') as archivo:
    db.execute(archivo.read())

usuarios = [] # (rut,nombre,email)
for _ in range(100):
    rut = generar_rut()
    nombre = faker.name()
    email = faker.unique.email()
    usuarios.append((rut,nombre,email))
    
    db.execute('INSERT INTO Usuarios (rut,nombre,email) VALUES (%s,%s,%s)', (rut, nombre, email))

topicos = [] #(id,nombre)
for _ in range(15):
    nombre = faker.unique.job()
    
    db.execute('INSERT INTO Topicos (nombre) VALUES (%s) RETURNING id', (nombre,))
    id = db.fetchone()[0]
    
    topicos.append((id,nombre))

usuarios_especialidades = [] #(rut,[esp_1,esp_2,...])
for rut,_,_ in usuarios:
    especialidades = set()
    
    for _ in range(random.randint(0,2)):
        rand_especialidad = random.choice(topicos)[0]
        if rand_especialidad not in especialidades:
            db.execute("INSERT INTO Usuarios_Especialidades (rut_usuario,id_topico) VALUES (%s,%s)", (rut,rand_especialidad))
            especialidades.add(rand_especialidad)
    
    usuarios_especialidades.append((rut,especialidades))

for _ in range(400):
    titulo = faker.sentence(nb_words=6)
    resumen = faker.text(max_nb_chars=150)
    
    autores_articulo = random.sample(usuarios, random.randint(1,5))
    rut_contacto = random.choice(autores_articulo)[0]
    
    topicos_articulo = random.sample(topicos, random.randint(1,3))
    
    db.execute("INSERT INTO Articulos (titulo,resumen,rut_contacto) VALUES (%s,%s,%s) RETURNING id", (titulo,resumen,rut_contacto))
    id_articulo = db.fetchone()[0]
    
    for id_topico,_ in topicos_articulo:
        db.execute("INSERT INTO Articulos_Topicos (id_articulo,id_topico) VALUES (%s,%s)", (id_articulo,id_topico))
    
    for rut,_,_ in autores_articulo:
        db.execute("INSERT INTO Articulos_Autores (id_articulo,rut_autor) VALUES (%s,%s)", (id_articulo,rut))
    
    revisores_articulo = []
    while len(revisores_articulo) < 3:
        revisor = random.choice(usuarios)
        
        if revisor[0] in [autor[0] for autor in autores_articulo] or revisor[0] in [revisor_articulo[0] for revisor_articulo in revisores_articulo]:
            continue
        
        db.execute("SELECT id_topico FROM Usuarios_Especialidades WHERE rut_usuario=%s", (revisor[0],))
        especialidades_revisor = [esp_revisor[0] for esp_revisor in db.fetchall()]
        
        if any(esp_revisor in [topico_id for topico_id, _ in topicos_articulo] for esp_revisor in especialidades_revisor):
            db.execute("INSERT INTO Articulos_Revisores (id_articulo,rut_revisor) VALUES (%s,%s)", (id_articulo, revisor[0]))
            revisores_articulo.append(revisor)

coneccion.commit()

db.close()
coneccion.close()