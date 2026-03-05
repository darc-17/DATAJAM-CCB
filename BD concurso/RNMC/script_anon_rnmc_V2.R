# Cargar el archivo .RDS y guardarlo como RNMC
ruta <- "C:/Users/MIGUE/OneDrive/Documentos/SCJ/2026/actividades_febrero/18_febrero_miercoles/RNMC.RDS"
RNMC <- readRDS(ruta)

# Verificar
dim(RNMC)
names(RNMC)
head(RNMC)

# Dejar solamente las filsa que tengan ANIO 2020 a 2025
RNMC <- RNMC[RNMC$ANIO %in% c(2020, 2021, 2022, 2023, 2024, 2025), ]

# Verificar
table(RNMC$ANIO, useNA = "ifany")
dim(RNMC)

# Dejar solamente las variables necesarias
vars <- c(
  "FECHA","ANIO","MES","DIA","HORA",
  "COD_LOCALIDAD","NOMBRE_LOCALIDAD","COD_UPZ","NOMBRE_UPZ",
  "TITULO","DESCRIPCION_TITULO",
  "CAPITULO","DESCRIPCION_CAPITULO",
  "ARTICULO","DESCRIPCION_ARTICULO",
  "COD_COMPORTAMIENTO","DESCRIPCION_COMPORTAMIENTO"
)

RNMC <- RNMC[, intersect(vars, names(RNMC)), drop = FALSE]

# Verificar
names(RNMC)
dim(RNMC)

# Crear DIA_SEMANA a partir de FECHA (en español y en mayúsculas)
dias_es <- c("DOMINGO","LUNES","MARTES","MIERCOLES","JUEVES","VIERNES","SABADO")

RNMC$DIA_SEMANA <- dias_es[as.POSIXlt(RNMC$FECHA)$wday + 1]

# Verificar
table(RNMC$DIA_SEMANA, useNA = "ifany")
head(RNMC[, c("FECHA","DIA_SEMANA")])

# Crear franjas horarias
# Asegurar HORA como número (sirve si viene como "0008", "0100", etc.)
hora_num <- as.integer(RNMC$HORA)

RNMC$FRANJA_HORARIA <- cut(
  hora_num,
  breaks = c(-1, 559, 1159, 1759, 2359),
  labels = c("MADRUGADA", "MAÑANA", "TARDE", "NOCHE")
)

# Verificar
table(RNMC$FRANJA_HORARIA, useNA = "ifany")
head(RNMC[, c("HORA", "FRANJA_HORARIA")])


# Verificar
dim(RNMC)
names(RNMC)
head(RNMC)

# Borrar columnas FECHA, DIA y HORA
RNMC <- RNMC[, !(names(RNMC) %in% c("FECHA", "DIA", "HORA")), drop = FALSE]

# Verificar
names(RNMC)
dim(RNMC)

# Reordenar columnas para que DIA_SEMANA y FRANJA_HORARIA queden justo después de MES
RNMC <- RNMC[, c(
  "ANIO", "MES", "DIA_SEMANA", "FRANJA_HORARIA",
  setdiff(names(RNMC), c("ANIO","MES","DIA_SEMANA","FRANJA_HORARIA"))
)]

# Verificar
names(RNMC)

# Exportar RNMC a CSV como RNMC_anon2.csv
ruta_salida <- "C:/Users/MIGUE/OneDrive/Documentos/SCJ/2026/actividades_febrero/18_febrero_miercoles/RNMC_anon_V2.csv"

write.csv(RNMC, file = ruta_salida, row.names = FALSE, fileEncoding = "UTF-8")

# confirmar que quedó
file.exists(ruta_salida)


