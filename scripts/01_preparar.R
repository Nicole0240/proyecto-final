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


##' 9. Aplicar criterios de limpieza

#' Crear una copia para realizar la limpieza
odepa_limpio <- odepa

#' Revisar la cantidad inicial de registros
nrow(odepa_limpio)
#' Los registros son 163400 como la base original.

#' Eliminar registros que no tengan información necesaria y observaciones 
#'con valores no validos
#'Se consideran las variables de fecha, producto, unidad de comercialización,
#' volumen y precios.
#' También se comprueba que los valores sean positivos y que los precios
#' mantengan el orden esperado: mínimo, promedio y máximo.
odepa_limpio <- odepa_limpio |>
  filter(
    !is.na(Fecha),
    !is.na(Producto),
    !is.na(`Unidad de comercializacion`),
    !is.na(Volumen),
    !is.na(`Precio minimo`),
    !is.na(`Precio maximo`),
    !is.na(`Precio promedio`),
    Volumen > 0,
    `Precio minimo` > 0,
    `Precio maximo` > 0,
    `Precio promedio` > 0,
    `Precio minimo` <= `Precio promedio`,
    `Precio promedio` <= `Precio maximo`)

#' Se conservan las observaciones que tienen información necesaria y 
#' valores positivos y consistentes.

#' Revisar la cantidad de registros después de la limpieza
nrow(odepa_limpio)
#' Se mantienen los 163400 registros iniciales.

#' Comparar los registros antes y después de la limpieza
nrow(odepa) - nrow(odepa_limpio)
#' El resultado es 0, por lo tanto, no fue necesario eliminar registros.
#' Esto indica que todas las observaciones cumplen con los criterios
#' establecidos para esta etapa.

#' Se revisan los valores faltantes por variable para comprobar
#' que la base continúe sin información incompleta.
colSums(is.na(odepa_limpio))
#' La revisión muestra 0 valores faltantes en todas las variables.
#' Por lo tanto, la base no presenta problemas de datos ausentes
#' en las variables revisadas.


##' 10. Identificar posibles valores atípicos

#' Agrupar por producto y unidad de comercialización
#' para comparar observaciones con características similares
odepa_limpio <- odepa_limpio |>
  group_by(Producto, `Unidad de comercializacion`) |>
  mutate(
    cantidad_grupo = n(),
    q1_precio = quantile(`Precio promedio`, 0.25, na.rm = TRUE), # calcular cuartiles y rango intercuartílico del precio
    q3_precio = quantile(`Precio promedio`, 0.75, na.rm = TRUE),
    rango_precio = IQR(`Precio promedio`, na.rm = TRUE),
    q1_volumen = quantile(Volumen, 0.25, na.rm = TRUE), # calcular cuartiles y rango intercuartílico del volumen
    q3_volumen = quantile(Volumen, 0.75, na.rm = TRUE),
    rango_volumen = IQR(Volumen, na.rm = TRUE),
    outlier_precio = cantidad_grupo >= 4 & # identificar posibles valores atípicos en el precio
      (`Precio promedio` < q1_precio - 1.5 * rango_precio |
          `Precio promedio` > q3_precio + 1.5 * rango_precio),
    outlier_volumen = cantidad_grupo >= 4 & # se aplica el mismo procedimiento para identificar
      (Volumen < q1_volumen - 1.5 * rango_volumen |  # posibles valores atípicos en el volumen comercializado.
          Volumen > q3_volumen + 1.5 * rango_volumen)) |>
  ungroup()

#' Aunque la base no presenta registros que deban eliminarse
#' según los criterios anteriores, es necesario revisar si existen
#' valores que se alejen considerablemente del comportamiento general.
#'
#' Los precios y volúmenes pueden variar según el producto
#' y la unidad de comercialización. Por esta razón, se agrupan
#' las observaciones según estas características para realizar
#' comparaciones entre registros similares.
#' 
#' Se utiliza el rango intercuartílico para identificar posibles
#' valores atípicos. Se consideran como tales las observaciones
#' que se encuentran por debajo de Q1 - 1,5 veces el rango
#' intercuartílico o por encima de Q3 + 1,5 veces dicho rango.
#'
#' Para realizar esta identificación se consideran grupos
#' que tengan al menos cuatro observaciones.


##' 11. Revisar los valores atípicos identificados

#' Contar posibles valores atípicos en precios
sum(odepa_limpio$outlier_precio, na.rm = TRUE)
#' Se identificaron 3.080 observaciones con posibles valores atípicos
#' en el precio promedio.

#' Contar posibles valores atípicos en volumen
sum(odepa_limpio$outlier_volumen, na.rm = TRUE)
#' Se identificaron 7.911 observaciones con posibles valores atípicos
#' en el volumen comercializado.

#' Observar algunos registros identificados
head(filter(
    odepa_limpio,
    outlier_precio | outlier_volumen))
#' La revisión de los primeros registros permite observar que los 
#' valores identificados corresponden a distintos productos, regiones y
#' mercados.
#' Esta identificación no significa necesariamente que sean errores,
#' ya que pueden representar diferencias reales en las condiciones
#' de comercialización.

#' Revisar las dimensiones de la base después de la limpieza
dim(odepa_limpio)
#' La base contiene 163.400 registros y 24 variables.
#' El aumento de variables se debe a los cálculos utilizados
#' para identificar los posibles valores atípicos.

#' Revisar nuevamente los valores faltantes
colSums(is.na(odepa_limpio))
#' La revisión muestra que las variables incorporadas
#' tampoco presentan valores faltantes.

#' Revisar las estadísticas de las variables principales
summary(odepa_limpio$Volumen)
#' El volumen presenta un mínimo de 1 y un máximo de 248.000.
#' La mediana es de 220 y el promedio es de 954,8.
#' La diferencia entre la mediana y el promedio muestra que existen
#' observaciones con volúmenes considerablemente mayores
#' que la mayoría de los registros.

summary(odepa_limpio$`Precio promedio`)
#' El precio promedio presenta un mínimo de 55,5 y un máximo de 990.000.
#' La mediana es de 12.000 y el promedio es de 27.206,2.
#' La diferencia entre ambos valores indica que existen observaciones
#' con precios elevados respecto de la distribución general.

#' Revisar la cantidad de observaciones identificadas
table(odepa_limpio$outlier_precio)
#' De las 163.400 observaciones, 3.080 fueron identificadas
#' como posibles valores atípicos en el precio y 160.320 no fueron marcadas.

table(odepa_limpio$outlier_volumen)
#' En el volumen, 7.911 observaciones fueron identificadas
#' como posibles valores atípicos y 155.489 no fueron marcadas.


##' 12. Preparar los nombres de las variables

#' Se cambian los nombres de algunas variables para facilitar
#' su identificación y utilización en los análisis posteriores.
#' Se reemplazan espacios y caracteres especiales por nombres
#' más simples y compatibles con el trabajo en Stata.
odepa_limpio <- odepa_limpio |>
  rename(
    id = `_id`,
    id_region = `ID region`,
    variedad_tipo = `Variedad / Tipo`,
    unidad_comercializacion = `Unidad de comercializacion`,
    precio_minimo = `Precio minimo`,
    precio_maximo = `Precio maximo`,
    precio_promedio = `Precio promedio`)


##' 13. Eliminar variables auxiliares

#' Durante la identificación de valores atípicos se crearon
#' variables auxiliares para calcular cuartiles y rangos intercuartílicos.
#' Como estos cálculos ya fueron realizados, se eliminan dichas columnas
#' para dejar una base más ordenada.
#' Se mantienen los indicadores outlier_precio y outlier_volumen
#' porque permiten reconocer las observaciones identificadas.
odepa_limpio <- odepa_limpio |>
  select(
    -cantidad_grupo,
    -q1_precio,
    -q3_precio,
    -rango_precio,
    -q1_volumen,
    -q3_volumen,
    -rango_volumen)


##' 14. Revisar la base final

#' Se revisa la estructura definitiva de la base
#' para comprobar que las variables tengan los tipos de datos esperados.
str(odepa_limpio)
#' La base final contiene 163.400 registros y 17 variables.
#' La fecha se encuentra en formato Date, el volumen y los precios
#' son variables numéricas, y las variables de identificación y 
#' clasificación se mantienen como texto.
#' Los indicadores de valores atípicos se conservan como variables lógicas.

#' Se comprueba la cantidad final de registros y variables.
dim(odepa_limpio)
#' El resultado confirma que la base contiene 163.400 filas y 
#' 17 columnas después del proceso de preparación.

#' Se revisan los nombres definitivos de las variables.
names(odepa_limpio)
#' Se confirma que los nombres fueron modificados.
#' La base conserva las variables originales necesarias para el análisis
#' y agrega los indicadores de posibles valores atípicos.

#' Se obtiene un resumen de la base después del proceso de preparación.
summary(odepa_limpio)
#' Los datos abarcan desde el 2 de enero hasta el 13 de noviembre de 2026.
#' El volumen comercializado presenta una mediana de 220 unidades
#' y un promedio de 954,8, lo que muestra diferencias importantes
#' entre las cantidades comercializadas.
#' El precio promedio presenta una mediana de $12.000
#' y una media de $27.206,2. El valor máximo alcanza $990.000,
#' por lo que existen observaciones con precios considerablemente mayores
#' que los valores centrales de la distribución.
#' Estas diferencias justifican mantener los indicadores de posibles
#' valores atípicos para revisarlos durante el análisis.

#' Se comprueba que los indicadores de posibles valores atípicos
#' se hayan conservado correctamente.
table(odepa_limpio$outlier_precio)
#' Se identificaron 3.080 observaciones con posibles valores atípicos
#' en el precio promedio y 160.320 sin esta condición.

table(odepa_limpio$outlier_volumen)
#' Se identificaron 7.911 observaciones con posibles valores atípicos
#' en el volumen y 155.489 sin esta condición.
#' Estos registros se mantienen porque las diferencias entre productos,
#' unidades de comercialización y mercados pueden generar valores extremos
#' que no necesariamente corresponden a errores.


##' 15. Exportar la base limpia

#' Se guarda la base preparada en formato CSV.
#' Este archivo permite utilizar los datos procesados
#' en otros programas o herramientas de análisis.
write.csv(odepa_limpio, "data/processed/odepa_limpio.csv", row.names = FALSE, na = "")

#' También se exporta la base en formato DTA.
#' Este formato permite abrir directamente los datos en Stata,
#' facilitando la continuidad del análisis en ese programa.
#' Se utiliza la versión 14 para mantener compatibilidad
#' con versiones de Stata que admiten este formato.
haven::write_dta(odepa_limpio, "data/processed/odepa_limpio.dta", version = 14)


##' 16. Verificar los archivos exportados

#' Se revisa el contenido de la carpeta processed
#' para comprobar que los archivos se hayan guardado.
list.files("data/processed")
#' Se confirma que se generaron los archivos odepa_limpio.csv
#' y odepa_limpio.dta dentro de la carpeta de datos procesados.

#' Se comprueba la existencia de los dos archivos exportados.
file.exists("data/processed/odepa_limpio.csv")
file.exists("data/processed/odepa_limpio.dta")
#' Ambos resultados TRUE confirman que los archivos se encuentran
#' guardados en las rutas indicadas.

#' Se vuelven a importar los archivos para comprobar
#' que puedan leerse correctamente después de su exportación.
revision_csv <- read.csv("data/processed/odepa_limpio.csv",
  stringsAsFactors = FALSE)

revision_dta <- haven::read_dta("data/processed/odepa_limpio.dta")

#' Se comparan las dimensiones de los archivos exportados
#' con la base final para comprobar que se hayan conservado
#' los registros y las variables.
dim(odepa_limpio)
dim(revision_csv)
dim(revision_dta)
#' Las tres bases presentan las mismas dimensiones:
#' 163.400 registros y 17 variables.
#' Esto confirma que ambos archivos se pueden volver a importar
#' y que mantienen la misma cantidad de filas y columnas que la base final.

#' Se muestra un mensaje para indicar que el proceso
#' de preparación y exportación ha finalizado.
cat("Proceso de preparación y exportación finalizado.\n")
#' El proceso de preparación y exportación terminó correctamente.
#' La base procesada queda disponible en formato csv para su revisión
#' y en formato DTA para continuar el análisis en Stata.

