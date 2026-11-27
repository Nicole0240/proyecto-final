# proyecto-final
Proyecto Final Fundamentos de Programación

## Hito 1 – Propuesta
Integrantes: Nicole Jara y María José Salinas  
Fecha: 17-11-2026

## Descripción del proyecto: El proyecto analiza la relación entre el 
volumen comercializado y los precios promedio mayoristas de frutas y 
hortalizas en Chile durante 2026, utilizando datos públicos de la 
Oficina de Estudios y Políticas Agrarias (ODEPA).

## Pregunta de investigación: ¿Cómo se relaciona el volumen 
comercializado con el precio promedio mayorista de frutas y hortalizas 
en los mercados mayoristas de Chile entre enero y noviembre de 2026?

## Fuente de datos

- Institución: ODEPA
- Fuente: https://datos.odepa.gob.cl/dataset/precios-mayoristas-de-frutas-y-hortalizas/resource/580beca0-e87e-4dd4-9e8a-0bd92773f4a6
- Archivo original: odepa_ene-nov-2026.csv
- Formato: csv
- Período: Enero a noviembre de 2026

## Herramientas y plan de trabajo

Se utilizarán R para la preparación de datos y visualización de 
resultados, y Stata para la estimación econométrica.


## Hito 2 – Avance del proyecto

## 1. Preparación de datos en R

Responsable del desarrollo: Nicole Jara
Se desarrolló el script scripts/01_preparar.R para importar, revisar, 
limpiar y preparar la base de datos original de ODEPA.

Las principales actividades realizadas fueron:
- Importación de la base original desde data/raw/.
- Revisión de la estructura, dimensiones, nombres y tipos de variables.
- Identificación y revisión de valores faltantes y registros duplicados.
- Conversión de la variable fecha y de las variables de precios a sus 
formatos correspondientes.
- Revisión de la consistencia entre los precios mínimos, promedio y 
máximos.
- Identificación de posibles valores atípicos en precios y volúmenes 
mediante el rango intercuartílico.
- Conservación de las observaciones identificadas como posibles valores 
atípicos, considerando que los valores extremos no necesariamente 
representan errores en los datos.
- Estandarización de los nombres de las variables.
- Eliminación de columnas auxiliares utilizadas durante los cálculos.

Resultados de la preparación: La base final quedó compuesta por 163.400 
registros y 17 variables.

Se identificaron:
- 3.080 observaciones con posibles valores atípicos en el precio promedio.
- 7.911 observaciones con posibles valores atípicos en el volumen comercializado.

Los indicadores de posibles valores atípicos se conservaron en la base para facilitar su revisión durante los análisis posteriores.

Archivos generados
El script exporta la base preparada en dos formatos:

- data/processed/odepa_limpio.csv: archivo para utilizar en otros 
programas y herramientas de análisis.
- data/processed/odepa_limpio.dta: archivo compatible con Stata para 
continuar el análisis econométrico.

Se verificó que ambos archivos pudieran importarse nuevamente y conservaran 
las mismas dimensiones que la base preparada en R.

## 2. Análisis en Stata

Responsable del desarrollo: María José Salinas

Esta sección queda pendiente de actualización con el trabajo desarrollado 
en Stata.

Se incorporará información sobre:

- Importación de la base procesada desde R.
- Revisión y análisis descriptivo de las variables.
- Estimación del modelo econométrico.
- Interpretación de los resultados obtenidos.
- Gráficos, tablas y archivos generados.

Script: scripts/02_modelar.do


## Estructura del repositorio

- data/raw/: datos originales descargados desde ODEPA
- data/processed/: datos preparados y exportados desde R
- scripts/: códigos de preparación en R y análisis en Stata
- output/figuras/: gráficos del proyecto
- output/tablas/: tablas y resultados
- README.md: descripción del proyecto, fuente de datos y avances realizados

## Estado del proyecto

Se completó la propuesta de investigación y el proceso de preparación 
de los datos en R. La base original fue revisada, limpiada y exportada 
en formatos csv y dta.


## Declaración de autoría humana y uso de tecnologías digitales emergentes

- Integrantes y responsabilidades: Nicole Jara y María José Salinas. 
Ambas participamos en la selección del tema, definición de la pregunta 
de investigación y organización del proyecto. Nicole estuvo a cargo de 
la preparación y limpieza de los datos en R, mientras que María José 
quedó a cargo del análisis y la estimación econométrica en Stata.
- Herramienta(s) de IA utilizada(s): ChatGPT
- Para qué se usaron: Se utilizó ChatGPT para resolver dudas sobre 
programación en R y Stata, comprender para qué sirven las funciones y 
comandos utilizados y solucionar errores durante el desarrollo de los 
scripts. En R, se consultó sobre funciones como `read.csv()` para 
importar los datos, str() y summary() para revisar su estructura y 
obtener resúmenes, y herramientas de dplyr como filter(), mutate(), 
select() y rename() para limpiar, transformar y organizar las 
variables. También se utilizó como apoyo para comprender el cálculo 
de rangos intercuartílicos (IQR), identificar posibles valores atípicos 
y exportar las bases en formatos CSV y DTA. Además, se consultó sobre 
especialmente sobre como trabajar con archivos, ejecutar códigos, 
realizar commits y sincronizar los cambios 
del repositorio.
- Qué hizo el equipo: Definimos el tema y la pregunta de investigación, 
buscamos y descargamos la base de datos de ODEPA y revisamos la 
información disponible. Para el trabajo en R, Nicole desarrolló el 
script de preparación, importó los datos originales, revisó sus 
dimensiones y variables, comprobó la existencia de valores faltantes y 
duplicados, transformó los datos y realizó la identificación de posibles 
valores atípicos. También interpretó los resultados obtenidos, organizó 
las variables y exportó la base preparada en formatos csv y dta para 
continuar el análisis. Por su parte, María José está a cargo del desarrollo 
del script en Stata, donde continuará con la revisión de los datos y la 
estimación econométrica. Ambas participamos en la organización del 
repositorio y el trabajo colaborativo mediante GitHub Desktop, 
compartiendo los avances y manteniendo los archivos actualizados.
- Verificación: Confirmamos que entendemos y podemos explicar todo lo 
que entregamos, incluido cada línea de código, los procedimientos 
realizados y la interpretación de los resultados. Los códigos fueron 
revisados y ejecutados por las integrantes, quienes verificamos que los 
procedimientos y archivos generados correspondieran al trabajo realizado.