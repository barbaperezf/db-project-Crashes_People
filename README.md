# Proyecto BD: Las personas en Chicago y sus accidentes

Un proyecto realizado para la materia de _Bases de Datos_.

## Contenidos

1. [Proyecto](#proyecto)
   i. [Integrantes del equipo](#integrantes-del-equipo)
   ii. [Descripción de los datos](#descripción-de-los-datos)
   iii. [Problema a estudiar](#problema-a-estudiar)
3. [Carga inicial y análisis preliminar](#carga-inicial-y-análisis-preliminar)
      i. [Carga inicia de datos](#carga-inicial-de-datos)
      ii. [Análisis preliminar de los datos](#análisis-preliminar-de-los-datos)
4. [Limpieza de datos](#limpieza-de-datos)
5. [Normalización de datos hasta cuarta formal normal](#normalización-de-datos-hasta-cuarta-formal-normal)
      i. [1NF](#1nf)
      ii. [2NF](#2nf)
      iii. [3NF](#3nf)
      iv. [BCNF](#bcnf)
      v. [4NF](#4nf)
6. [Análisis de datos a través de consultas SQL](#análisis-de-datos-a-través-de-consultas-sql)
7. [Creación de atributos para entrenamiento de modelos](#creación-de-atributos-para-entrenamiento-de-modelos)
8. [Conclusiones](#conclusiones)



## Proyecto


### Integrantes del equipo:

* [Fernando Barba Pérez](https://github.com/barbaperezf)
* Enrique Gómez Carapia


### Descripción de los datos
Este conjunto de datos proporciona información sobre personas involucradas en accidentes de tráfico en Chicago.
Cada tupla representa a un individuo relacionado a un accidente.
Abarca peatones, ciclistas, pasajeros, conductores o cualquier involucrado con un elemento automovilistico.
Los registros son elaborados por la policía de Chigado y actualizados cada 30 días.
Los datos se encuentran en [este link](https://data.cityofchicago.org/Transportation/Traffic-Crashes-People/u6pd-qa9d/about_data).


**Información general de la base de datos:** 

* 1,830,000 renglones (cada fila es una persona relacionada a algún accidente)
* 29 columnas

Las siguientes son algunas de las variables disponibles en el conjunto de datos:

* Identificador único de la persona
* Tipo de persona (conductor, pasajero, peatón, ciclista, etc)
* Ciudad de residencia de la persona involucrada en el accidente
* Equipo de seguridad utilizado por la persona (cinturón de seguridad, casco, etc)
* Severidad de la lesión
* Condición física del conductor en el momento del accidente


### Problema a estudiar

Con este proyecto, buscamos obtener tendencias de comportamiento humano y entender a mayor profundidad que nuestras acciones nos afectan a nosotros y a terceros.



## Carga inicial y análisis preliminar

### Carga inicial de datos

Para insertar los datos en bruto se debe primero correr el script `raw_data_schema_creation.sql` y posteriormente ejecutar el siguiente comando en una sesión de línea de comandos de Postgres.

```
\copy raw.crashes_people (person_id, person_type, crash_record_id, vehicle_id, crash_date, seat_no, city, state, zipcode, sex, age, drivers_license_state, drivers_license_class, safety_equipment, airbag_deployed, ejection, injury_classification, hospital, ems_agency, ems_run_no, driver_action, driver_vision, physical_condition, pedpedal_action, pedpedal_visibility, pedpedal_location, bac_result, bac_result_value,cell_phone_use) 
FROM 'path_to_downloaded_csv' 
WITH (FORMAT CSV, HEADER true, DELIMITER ',');
```


### Análisis preliminar de los datos

Para el análisi preeliminar de los datos, corrimos el codigo que está en el script `raw_data_schema_creation.sql`. Aquí nos percatamos de distintas problemas que habría en la limpia de datos, como edades negativas, errores ortográficos o de dedo en las columnas de ciudad y hospital. Adicionalmente, hay ciertas columnas que nos proporcionan información valiosa y serán cortadas más adelante. También, en los últimos atributos, se ve que hay únicamente pocas opciones distintas, lo cual aluden al uso de mejores técnicas para la recolleción de datos.



## Limpieza de datos

El proceso de limpieza sigue una metodología de refresh destructiuvo, por lo que cada vez que se corra se generará desde cero el esquema y las tablas correspondientes. El script correspondiente es el llamado: data_cleaning.sql.

**Las columnas eliminadas fueron:**
* ejection
* drivers_license_state
* drivers_license_class
* ems_run_no
* pedpedal_location
 
Adicionalmente, se usó el TRIMM(UPPER(x)) a la hora de insertar los datos para evitar problemas con espacios al final y con las minúsulas. 

**Limpieza de las columnas:**
* **Ciudad –>** Primero se corrigieron los errores de dedo y ortográficos. Después se aruparon las ciudades que tenían menos de 100 entradas y se pusieron como _otros_.
* **Estado –>** Se hizo un query para que si una ciudad tuviera relacionada varios estados, se tomara el estado que tiene relacionado el mayor numero de esa ciudad y se pusiera para todas las demás.
* **Código Postal –>** Se quitó los códigos postales que incluían letras.
* **Número de asiento y tipo de persona –>** En la descripción del atributo seat_no (número de asiento) de [la página](https://data.cityofchicago.org/Transportation/Traffic-Crashes-People/u6pd-qa9d/about_data) dice que el 1 es para el conductor, sin embargo, había conductores con asiento nulo o pasajeros con número asiento igual a 1. Se cambió para que se respetara dicha descripción.
* **Identificador del vehículo –>** Si un conductor tenía identificador de veículo nulo, se cambió a 'identificador no disponible'.
* **Género –>** Se puso para que solo hubiera dos géneros.
* **Edad –>** Se cambiaron las edades negativas a nulas para que no afectara las consultas como promedios, sumas, etc.
* **Equipo de seguridad ->** Cambiar valores nulos por _desconocido_.
* **Despliegue de bolsa de aire –>** Modificar los valores nulos dependiendo el tipo de persona.
* **Hospital –>** Primero se corrigieron los errores de dedo y ortográficos. También se agruparon los tipos de respuestas (rechazado, auto transportado, sin lesión, etc.). Finalmente se agruparon las demás respuestas a _hospital_, indicando que si fueron llevadas al hospital por las autoridades.
* **Agencia de emergencia en la escena –>** Igual que Ciudad y Hospital, se corrigen errores de dedo y ortográficos. Después de argupan en categoría más grandes. Finalmente, cualquier valor que tuviera menos de 50 entradas fue metida en _otros_.
* **Condición física –>** Se modificó los valores de _había estado tomando_ a _perjudicado por consumo de alcohol_.
* **Uso de celular –>** Se quitaron los valores nulos y se cambiaron a _si_ si la columna de Acción del Conductor decía que había estado usando el celular.

A demás de esto, se quitó los NULLs de la mayoría de las columnas, excepto donde hacía sentido tener valores nulos.

## Normalización de datos hasta cuarta formal normal

Es el proceso mediante el cual se busca llevar a las relvars de una base de datos a formas (estructuras) normales. Esto es para arreglar fallas lógicas, reducir la redundancia en diseños sin fallas de lógica en otros sentidos y eliminan las anomalías de inserción, borrado y modificación.

### 1NF

Los datos desde un inicio ya estaban en la primera forma normal pues para cada tupla, solo había un valor. No había necesidad de descomponer.

### 2NF

Los datos también ya estban en segunda forma normal pues {person_id} es la única llave de la relvar y la única dependencia funcional de esta es '{person_id} –> E'. Es decir, para todas las dependencias funcionales que salen de llaves son irreducibles.

### 3NF

Los datos también ya estaban en tercera forma normal pues todas las dependencias funcionales de la relvar salen de una superllave.

### BCNF

_Las únicas FD que se mantienen en una relvar en BCNF son triviales o bien son “flechas que salen de súper llaves"_. Esto se cumple en esta relvar, pues al igual que en la 3NF, la dependencia funcional sale de una superllave.

### 4NF

Aquí se presentan algunas dependencias multivaluadas. Para hacer que todas las dependencias multivaluados no triviales estén implicadas por llaves y que hiciera sentido, descompusimos la tabla en 5 tablas:
* id
   * Contiene únicamente la llave principal. Esto se hizo para que en las otras tablas se pudiera poner _person_id_ como llave foránea y se pudieran hacer JOINS con esa llave.
* person
   * Contiene _person_id_ como llave foránea e _id_ de esta tabla y todos los atributos que hablan de las características del individuo (_person_type, seat_no, city, state, zipcode, sex, age_).
* injury
   * Contiene _person_id_ como llave foránea e _id_ de esta tabla y todos los atributos que hacen referencia a las lesiones que tuvo la persona, así como la forma en la que lo trataron (_safety_equipment, airbag_deployed, injury_classification, hospital, ems_agency_).
* accident
   * Contiene _person_id_ como llave foránea e _id_ de esta tabla y todos los atributos que tratan con el accidente en sí y las causas de este (_crash_date, driver_action, driver_vision, physical_condition, pedpedal_action, pedpedal_visibility, pedpedal_location, bac_result, bac_result_value, cell_phone_use_).
* ref
   * Contiene _person_id_ como llave foránea e _id_ de esta tabla, _crash_record_id_ y _vehicle_id_. Estas dos últimas tablas pueden ser usadas para unirlas con otras bases de datos del portal de Chicago con los mismo nombres.



## Análisis de datos a través de consultas SQL

x



## Creación de atributos para entrenamiento de modelos

x



## Conclusiones

x
