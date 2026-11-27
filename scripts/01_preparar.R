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


##' 5. Revisar valores faltantes y duplicados

#' Contar el total de valores faltantes
sum(is.na(odepa_original))
#' Se cuenta el total de valores faltantes de la base.
#' Esto permite conocer si existen registros con información incompleta
#' que puedan afectar los resultados del análisis. Donde no se 
#' encuentran valores pérdidos.

#' Revisar los valores faltantes por variable
colSums(is.na(odepa_original))
#' Se revisan los valores faltantes por variable para identificar 
#' dónde se encuentran. Donde no se encueentran valores faltantes.

#' Contar registros duplicados
sum(duplicated(odepa_original))
#' Se comprueba si existen filas completamente duplicadas,
#' ya que podrían generar observaciones repetidas en el análisis. La 
#' base no cuenta con registros duplicadpos.

#' Revisar si existen identificadores repetidos
length(unique(odepa_original$`_id`))
nrow(odepa_original)
#' Se cuenta la cantidad de identificadores únicos y se compara con el
#' total de registros para revisar si existen identificadores repetidos.
#' Existen 163400 datos identificados en ambos.


##' 6. Transformar tipos de datos

#' Crear una copia para trabajar con los datos
odepa <- odepa_original
#' Se crea una copia de la base original para realizar
#' las transformaciones sin modificar los datos iniciales.

#' Convertir la variable de fecha al formato Date
odepa$Fecha <- as.Date(odepa$Fecha)
#' Se transforma la variable Fecha al formato Date.
#' Esto permite trabajar correctamente con fechas y periodos.

#' Convertir las variables de precios a formato numérico
odepa$`Precio minimo` <- as.numeric( 
  gsub(",", ".", as.character(odepa$`Precio minimo`), fixed = TRUE))

odepa$`Precio maximo` <- as.numeric(
  gsub(",", ".", as.character(odepa$`Precio maximo`), fixed = TRUE))

odepa$`Precio promedio` <- as.numeric(
  gsub(",", ".", as.character(odepa$`Precio promedio`), fixed = TRUE))
#' Se convierten las variables de precios a formato numérico.
#' Primero se transforman a texto para reemplazar posibles
#' comas decimales por puntos y luego se convierten a números.

#' Revisar los tipos de datos después de la transformación
str(odepa)
#' Se revisa nuevamente la estructura para comprobar que las 
#' transformaciones se hayan realizado correctamente.


##' 7. Revisión inicial de volumen y precios

#' Obtener estadísticas generales del volumen
summary(odepa$Volumen)
#' Se obtiene un resumen del volumen comercializado para conocer sus 
#' valores mínimos, máximos, su media y mediana las cuales son 
#' #' mínimo 1.0, máximo 248000.0, mediana 222.0 y media 954.8.

#' Obtener estadísticas generales de los precios
summary(odepa$`Precio minimo`)
summary(odepa$`Precio maximo`)
summary(odepa$`Precio promedio`)
#' Se revisan los precios mínimo, máximo y promedio para conocer su
#' comportamiento general.

#' Revisar si existen valores iguales o inferiores a cero
sum(odepa$Volumen <= 0, na.rm = TRUE)
sum(odepa$`Precio minimo` <= 0, na.rm = TRUE)
sum(odepa$`Precio maximo` <= 0, na.rm = TRUE)
sum(odepa$`Precio promedio` <= 0, na.rm = TRUE)
#' Se comprueba si existen volúmenes o precios iguales o inferiores a cero.
#' Estos valores deben revisarse porque no representan observaciones
#' válidas para el análisis de precios y cantidades comercializadas.

#' Comprobar que los precios respeten el orden esperado
sum(odepa$`Precio minimo` > odepa$`Precio promedio`, na.rm = TRUE)
sum(odepa$`Precio promedio` > odepa$`Precio maximo`, na.rm = TRUE)
#' Se verifica la consistencia entre los precios.
#' El precio mínimo no debería superar al promedio
#' y el promedio no debería superar al precio máximo.

#' Revisar el periodo que cubren los datos
range(odepa$Fecha, na.rm = TRUE)
#' Se revisa el rango de fechas para conocer el periodo que 
#' realmente cubre la base.


##' 8. Revisar posibles problemas de conversión

#' Comprobar valores faltantes después de transformar las variables
colSums(is.na(odepa))
#' Se vuelven a contar los valores faltantes después de transformar
#' las variables para identificar si alguna conversión generó valores NA.

#' Revisar valores faltantes en las variables transformadas
sum(is.na(odepa$Fecha))
sum(is.na(odepa$`Precio minimo`))
sum(is.na(odepa$`Precio maximo`))
sum(is.na(odepa$`Precio promedio`))
#' Se revisan específicamente las variables transformadas,
#' ya que son las que podrían presentar problemas de conversión.


#' Revisar las dimensiones de la base
dim(odepa)
#' Se revisan las dimensiones para comprobar que la transformación no 
#' haya modificado la cantidad de registros.

