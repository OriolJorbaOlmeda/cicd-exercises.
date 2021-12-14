Antes de empezar con la creación de la pipeline, hay que hacer el setup de Jenkins en Docker. Para ello hay que abrir el terminal y hacer un pull de una imagen de Jenkins, en mi caso he escogido la 2.324-alpine:

- docker pull jenkins/jenkins:2.324-alpine

Depués de hacer el pull, hay que hacer un run de la imagen y que esta exponga en un puerto. En mi caso en el puerto 8080.

- docker run -p 8080:8080 jenkins/jenkins:2.324-alpine

Cuando ejecutemos el comando, nos dará una contraseña que deberemos utilizar como se ve en la (Imagenes/Imagen1.png). Una vez dentro, debemos seguir los pasos para arrancar Jenkins. Después pedirá crear un usuario. Cuando todo esto este hecho, podremos ver ya la interfaz de Jenkins (Imagenes/Imagen_2.png).

Voy a utiliza Git como gestor de versiones, así que crearé un proyecto en mi repositrio de GitHub con el nombre CI-CD-project. Para que Jenkins pueda operar con GitHub, hay que tener instalado el pluggin de de GitHub el cual le permite hacer pull de cualquier repositorio de GitHub. Puede ser que ya lo tengamos intalado, como es mi caso.

Para poder vincularlos, primero crearemos el proyecto pipeline de Jenkins. El primer paso es ir a Item nova, escribir el nombre del proyecto, seleccionar la opción de pipeline y le damos a OK. Una vez creado, nos dirigirà al project from (Imagenes/Imagen_3.png). Como se puede ver en la imagen, hay una opción de GitHub project, la cual seleccionaremos y escribiremos el link de nuestro repositorio de GitHub. Una vez creado, aun no tendremos información para procesar, pero ya estarà nustra pieline conectada a nuestro repositorio de GitHub. En la (Imagenes/Imagen_4.png) se puede ver en las opciones de la izquierda como aparece la opción de GitHub, la qual nos reconduce directamente a nuestro repostorio de GitHub.

La aplicación que voy a utilizar, es un simple HelloWorld con python y el Framework de Flask(Imagenes/Imagen_5.png). En mi caso, voy a hacer todo el proceso desde la rama de master, así que he subido la aplicación a GitHub con el proceso visto en clase en clases anteriores.ç

Pipeline:

A partir de aquí es donde empieza la construcción de la pipeline CI/CD para esta practica. Hay dos opciones, hecerlo por Pipeline script o por Pipeline script form SCM, eso permite coger la información de un Jenkinsfile que se encuentre en nuestro repositorio GitHub. Para tenerlo allí, primero lo crearé en mi repositorio local, y lo subiré a GitHub, como he hecho con el fichero demo.py. Para añadir algo de código inicialmente y comprovar que este método funciona, le itroduciré unos comandos sencillo con echo, como se puede ver en la (Imagenes/Imagen_6.png). Con el Jenkinsfile creado y subido a nuestro repositorio, le diremos a Jenkins que definiremos nuestro script con SCM (Imagenes/Imagen_7.png).

Si ha continuación, en el dashboard le damos a build en nuestro proyceto, veremos que se empieza a construir. Al terminar nos tiene que salir los diferentes pasos (Imagenes/Imagen_8.png). Podremos ver las cosas más claras si nos instalamos el pluggin de Blue Ocean, el cual nos permite ver de forma más senzilla y entendible (Imagenes/Imagen_9.png).

Una vez creado, toca inicializa el proceso de nuestra Pipeline. El primer paso es hacer la colnación de nuestro Repositorio de GitHub, y de esa forma tener a mano todos los ficheros necesarios para realizar el proceso.

- git 'https://github.com/OriolJorbaOlmeda/CI-CD-project'

La Pipeline se puede ver detallada en el Jenkinsfile.
El siguiente paso es hacer el build del propio gestor de paquetes. Utilizaremos el fichero requirements.txt par ainstalar lo necesario y depués instalaremos Flask. El gestor de paquetes es Pip, propio de Python.

- sh 'virtualenv venv && . venv/bin/activate && pip install -r requirements.txt'

Una vez tengamos el entorno construido, toca hacer el test de nuestra aplicación. El código se encuentra en el fichero test.py (Imagenes/Imagen10.png). Este es un test unitario que comprueba que la salida del fichero demo es 'Hello world'. La instrucción es la siguiente:

- sh 'pytest test.py'

Con pytest ejecutamos el test que este realizando ese fichero python. Como se puede ver en la (Imagenes/Imagen_11.png), el test se realiza correctamente.
Con el test realizado, toca crear un contenedor docker el cual puede ejecutar nuestra aplicación.

Deberemos crear un Dockerfile con la imagen de Python3. En la (Imagenes/Imagen_12.png) se puede ver la configuración, que a la vez está en el fichero Dockerfile. El Entrypoint serà python y el cmd demo.py, de esa forma ejecutará el fichero directamente. para contruir esa imagen, lo haremos con:

- sh'docker build -t flask-app:latest .'

I para ejecutarlo, la siguiente:

- sh 'docker run -d -p 5000:5000 flask-app'

haremos correr la Imagen en el purto 5000 de nuestro localhost y en segundo plano. Como se puede ver en la (Imagenes/Imagen_13.png), este funciona correctamente.

El siguiente paso es subir esa imagen a DockerHub, y de esa forma poder gestionar las versiones de esta. Para hacerlo hay que realizar dos comandos que se puden ver en el Jenkisnfile.

- sh 'docker tag flask-oriol:1.0 oriol8/flask-app:flask-oriol:1.0'

- sh 'docker push oriol8/flask-app'

Si nos dirigimos a DockerHub, podremos ver que tenemos la version latest de nuestra aplicación, ya que no le hemos aplicado ningún falg en especifico (Imagenes/Imagen_14.png).

Con todo esto hecho, solo falta hacer nuestro despliegue de Kubernetes para poder lanzar nnuestra aplicación. Para ello se debe crear un Deployment para crear las replicas que queramos de nuestros Pods, y luego un Service para gestionarlos. Este tendra como imagen a oriol8/flask-app:latest, la cual es la Imagen de nuestra aplicación que hemos subido a dockerHub (Imagenes/Imagen_15.png).

Después será necesario el service, el cual podemos ver en la (Imagenes/Imagen_16.png), el cual hace referencia a los Pods creados por el deployment.

Finalmente si aplicamos las siguientes comandas:

- kubectl apply -f deploy.yaml

- kubectl apply -f service.yaml

- kubectl get all

Podremos ver nuestro despliegue de Kubernetes al completo. (Imagenes/Imagen_17.png).

En la (Imagenes/Imagen_18.png), podemos ver como queda finalmente nuestra Pipeline con el pluggin blue ocean.
