library(ncdf4)
library(ggplot2)
library(dplyr)
library(maps)
library(stringr)
library(animation)
library(here)
library(lubridate)

plots <- list()

model_version <- "tuning_v3"
start_date <- date("2021-02-01")
end_date <- date("2021-03-31")
species <- "CORY"
variable <- ""
model_name <- if_else(str_detect(model_version, "tuning"), "tuning", "model_version")

# Support All Species
limits <- case_when(
  species == "ALNU" & variable == "tune" ~ c(0, 2.5),
  species == "BETU" & variable == "tune" ~ c(0, 3),
  species == "POAC" & variable == "tune" ~ c(0, 0.6),
  species == "CORY" & variable == "tune" ~ c(0, 6),
  species == "ALNU" & variable == "" ~ c(0, 3000),
  species == "BETU" & variable == "" ~ c(0, 3000),
  species == "POAC" & variable == "" ~ c(0, 3000),
  species == "CORY" & variable == "" ~ c(0, 3000),
  species == "ALNU" & variable == "tthre" ~ c(10000, 40000),
  species == "BETU" & variable == "tthre" ~ c(10000, 60000),
  species == "CORY" & variable == "tthre" ~ c(10000, 40000),
  species == "POAC" & variable == "saisl" ~ c(0, 200),
  species == "ALNU" & variable == "tthrs" ~ c(0, 14000),
  species == "BETU" & variable == "tthrs" ~ c(0, 30000),
  species == "CORY" & variable == "tthrs" ~ c(0, 14000),
  species == "POAC" & variable == "tthrs" ~ c(0, 14000),
)
while (start_date <= end_date) {
  date <- paste(c(str_sub(start_date, c(3, 6, 9), c(4, 7, 10)), "00"), collapse = "")
  for (hour in seq(0, 23, 1)) {
    i <- sprintf("%02d", hour)
    nc_path <- paste0("/scratch/sadamov/wd/", substr(as.character(date), 1, 2), "_", tolower(species), "_", model_version, "/", date, "_c1e_tsa_", tolower(species), "_tuning/lm_coarse/lfff00", i, "0000") # This can be any netCDF file with POAC (e.g.)

    system(paste0("fxfilter --force -s ", species, variable, " ", nc_path, " -o ", nc_path, "_filtered --dics=/store/s83/sadamov/config/dictionary_cosmo.txt"))
    system(paste0("fxconvert --force nc ", nc_path, "_filtered -o ", nc_path, "_filtered.nc --dics=/store/s83/sadamov/config/dictionary_cosmo.txt"))

    con <- nc_open(paste0(nc_path, "_filtered.nc"))
    if (con$ndims == 5) {
      layer <- ncvar_get(con, paste0(species, variable))[, , 80]
    } else {
      layer <- ncvar_get(con, paste0(species, variable))
    }
    x <- ncvar_get(con, "lon_1")
    y <- ncvar_get(con, "lat_1")
    nc_close(con)

    if (variable %in% c(
      "ALNU", "ALNUress", "ALNUreso", "ALNUfe ", "ALNUtthre ", "ALNUtthrs ",
      "BETU", "BETUress", "BETUreso", "BETUfe ", "BETUtthre ", "BETUtthrs ",
      "CORY", "CORYress", "CORYreso", "CORYfe ", "CORYtthre ", "CORYtthrs ",
      "POAC", "POACress", "POACreso", "POACfe ", "POACsaisl ", "POACtthrs "
    )) {
      layer <- log10(layer + 1)
    }

    tb_data <- tibble(x = c(x), y = c(y), layer = c(layer))

    plots[[paste0(substr(as.character(date), 1, 6), as.character(i))]] <- ggplot(tb_data) +
      geom_tile(aes(x, y, fill = layer, width = 0.018, height = 0.011)) +
      theme_bw() +
      borders("world", xlim = range(tb_data$x), ylim = range(tb_data$y), colour = "white") +
      scale_fill_viridis_c(limits = limits, breaks = round(seq(limits[1], limits[2], (limits[2] - limits[1]) / 4), 2)) +
      coord_fixed(xlim = range(tb_data$x), ylim = range(tb_data$y)) +
      ggtitle(paste0(species, variable, "-Field on 20", substr(as.character(date), 1, 6), " at ", i, "h")) +
      labs(fill = paste(species, variable)) +
      xlab("Longitude [East]") +
      ylab("Latitude [North]") +
      theme(text = element_text(size = 18)) +
      coord_quickmap(xlim = range(tb_data$x), ylim = range(tb_data$y))
  }
  start_date <- start_date + days(1)
}

saveGIF(
  {
    for (j in seq_along(plots)) {
      print(plots[[j]])
    }
  },
  movie.name = paste0(here(), "/output/map_", model_version, "_", species, variable, "_", start_date, ".gif"),
  interval = 2 / 25,
  ani.width = 580,
  ani.height = 270)
