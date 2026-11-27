* ============================================================
* Proyecto: Precios mayoristas de frutas y hortalizas - ODEPA
* Integrantes: Nicole Jara y Maria Jose Salinas
* Programa: Stata 18
* Archivo: 02_modelar.do
* Objetivo: Estimar la relacion entre volumen y precio promedio
* ============================================================
* 1. Limpiar memoria
clear all
 //Eliminar los datos y elementos almacenados previamente en la memoria de Stata.
* 2. Cerrar posibles registros anteriores
capture log close
// Cierra cualquier archivo de registro que pudiera encontrarse abierto.

* ============================================================
* 2. ESTABLECIMIENTO DEL DIRECTORIO DE TRABAJO
* ------------------------------------------------------------
* Comando: cd
cd "C:/Users/ricar/Documents/Fund Programación"
//Definir la carpeta donde se encuentran los archivos utilizados en el proyecto.

* ============================================================
* 3. INICIO DEL REGISTRO DE RESULTADOS
* ------------------------------------------------------------
log using "analisis_precios.log", text replace
//Guarda los resultados y procedimientos ejecutados durante el analisis en un archivo de texto.

* ============================================================
* 4. CARGA DE LA BASE DE DATOS LIMPIA
* ------------------------------------------------------------
use "odepa_limpio.dta", clear
//Carga la base de datos limpia de ODEPA en formato Stata para comenzar el analisis.

* ============================================================
* 5. DESCRIPCION GENERAL DE LA BASE DE DATOS
* ------------------------------------------------------------
describe
//Identifica las variables, sus tipos de datos, formatos y etiquetas.
count
//Cuenta el total de observaciones.

* ============================================================
* 6. REVISION DE LAS OBSERVACIONES
* ------------------------------------------------------------
list in 1/10

//Permite visualizar los primeros diez registros para comprobar la informacion contenida en la base de datos.


list in -10/l
//Permite visualizar los ultimos diez registros de la base de datos.

* ============================================================
* 7. IDENTIFICACION DE REGISTROS DUPLICADOS
* ------------------------------------------------------------
duplicates report
//Identifica observaciones duplicadas considerando todas las variables de la base de datos.

* ============================================================
* 8. IDENTIFICACION DE VALORES FALTANTES
* ------------------------------------------------------------
misstable summarize
//Identifica las variables que presentan valores faltantes y muestra su cantidad.

* ============================================================
* 9. ESTADISTICAS DESCRIPTIVAS GENERALES
* ------------------------------------------------------------
summarize
 //Calcula estadisticas basicas de las variables numericas, incluyendo media, desviacion estandar, valor minimo y valor maximo.

* ============================================================
* 10. ESTADISTICAS DESCRIPTIVAS DE PRECIOS Y VOLUMEN
* ------------------------------------------------------------
summarize Volumen precio_minimo precio_maximo precio_promedio, detail
//Presenta estadisticas detalladas de las  de precios y volumen, incluyendo mediana,percentiles y dispersion de los datos.

* ============================================================
* 11. IDENTIFICACION Y ANALISIS DE VALORES ATIPICOS
* ------------------------------------------------------------
tabulate outlier_precio
//Identifica la cantidad de observaciones clasificadas como valores atipicos en los precios.

tabulate outlier_volumen
//Identifica la cantidad de observaciones clasificadas como valores atipicos en el volumen.

count if outlier_precio == 1

count if outlier_volumen == 1
//Calcula la cantidad total de registros identificados como atipicos en cada variable.

* ============================================================
* 12. ANALISIS DE FRECUENCIAS POR REGION
* ------------------------------------------------------------
tabulate Region
//Identifica la cantidad de registros correspondientes a cada region.


* ============================================================
* 13. ANALISIS DE FRECUENCIAS POR MERCADO
* ------------------------------------------------------------

tabulate Mercado

//Identifica la cantidad de registros correspondientes a cada mercado.


* ============================================================
* 14. ANALISIS DE FRECUENCIAS POR SUBSECTOR
* ------------------------------------------------------------
tabulate Subsector
// Presenta la distribucion de observaciones segun el subsector de los productos.

* ============================================================
* 15. ANALISIS DE FRECUENCIAS POR PRODUCTO
* ------------------------------------------------------------
tabulate Producto
//Identifica los productos registrados  y la frecuencia de sus observaciones.

* ============================================================
* 16. ANALISIS DE FRECUENCIAS POR CALIDAD
* ------------------------------------------------------------
tabulate Calidad
//Identifica la frecuencia de registros segun la calidad de los productos.

