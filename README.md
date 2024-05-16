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
Los registros son elaborados por la policía de Chigado y actualizados cada 30 días
(Los datos se encuentran en [este link](https://data.cityofchicago.org/Transportation/Traffic-Crashes-People/u6pd-qa9d/about_data))

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


## Normalización de datos hasta cuarta formal normal

### 1NF


### 2NF


### 3NF


### BCNF


### 4NF


## Análisis de datos a través de consultas SQL


## Creación de atributos para entrenamiento de modelos


## Conclusiones
