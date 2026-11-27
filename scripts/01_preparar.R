#' Proyecto Final - Fundamentos de Programación para Análisis Económico
#' Tema: Volumen comercializado y precios mayoristas de frutas y hortalizas
#' Integrantes: Nicole Jara y María José Salinas
#' Fecha: 2026-11-26
#' Institución: Oficina de Estudios y Políticas Agrarias (ODEPA)
#' Fuente: https://datos.odepa.gob.cl/dataset/precios-mayoristas-de-frutas-y hortalizas/resource/580beca0-e87e-4dd4-9e8a-0bd92773f4a6  
#' Periodo: Enero a noviembre de 2026


##' 1. Cargar librerías
library(dplyr)
#' Se carga dplyr para utilizar funciones que permiten manipular y 
#' organizar los datos durante el proceso de limpieza.


##' 2. Configuración de directorios
#' Revisar el directorio de trabajo
getwd()
#' Se revisa el directorio de trabajo para comprobar que RStudio
#' este ubicado en la carpeta principal del proyecto.

#' Definir la ubicación del archivo original
archivo_original <- "data/raw/odepa_ene-nov-2026.csv"
#' Se guarda la ruta del archivo original para facilitar
#' su importacion durante el proceso de limpieza.

#' Crear las carpetas necesarias para guardar los resultados
dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("output/figuras", recursive = TRUE, showWarnings = FALSE)
dir.create("output/tablas", recursive = TRUE, showWarnings = FALSE)


##' 3. Importar los datos originales
odepa_original <- read.csv(archivo_original, stringsAsFactors = FALSE,
  check.names = FALSE)
#' Se importa el archivo csv de odepa y se guarda en un objeto
#' llamado odepa_original para conservar una copia de los datos iniciales.
#' Se utiliza check.names = FALSE para mantener los nombres originales
#' de las variables, incluyendo espacios y caracteres especiales.

#' Revisar las dimensiones de la base
dim(odepa_original)
#' Se revisan las dimensiones para conocer la cantidad de registros
#' y variables que contiene la base donde tiene 163400 observaciones y 
#' 15 variables.

#' Revisar los nombres de las variables
names(odepa_original)
#' Se identifican los nombres de las variables disponibles.

#' Observar los primeros registros
head(odepa_original)
#' Se observan los primeros registros para conocer como vienen presentados 
#' los datos originales.


##' 4. Revisar la estructura de los datos
str(odepa_original)
#' Se revisa la estructura de cada variable para identificar si está 
#' almacenada como texto, número u otro tipo de dato.

#' Obtener un resumen general de las variables
summary(odepa_original)
#' Se obtiene un resumen estadístico de las variables para observar sus 
#' valores y detectar posibles situaciones que deban revisarse antes 
#' de comenzar la limpieza.