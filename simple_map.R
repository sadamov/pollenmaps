library(ncdf4)
library(ggplot2)
library(dplyr)
library(maps)

# Path to GRIB File
grib_path <- "/scratch/sadamov/wd/20_cory_tuning_v3/20021500_c1e_tsa_cory_tuning/lm_coarse/lfff01000000"
field <- "CORY"

# Filtering the field specified above to gain speed
system(paste0(
  "fxfilter --force -s ",
  field,
  " ",
  grib_path,
  " -o ",
  grib_path,
  "_filtered --dics=/store/s83/sadamov/config/dictionary_cosmo.txt"
))

# Converting the GRIB File to NetCDF (this is the only way, approved by MeteoSwiss)
system(paste0(
  "fxconvert --force nc ",
  grib_path,
  "_filtered -o ",
  grib_path,
  "_filtered.nc --dics=/store/s83/sadamov/config/dictionary_cosmo.txt"
))

# Or directly path to NetCDF File
nc_path <- paste0(grib_path, "_filtered.nc")

# Retrieve field from NetCDF File
con <- nc_open(paste0(nc_path))
# Level 80 is the one closest to the ground in Cosmo
layer <- ncvar_get(con, field)[, , 80]
# Already unrotated coordinates, ready for plotting
x <- ncvar_get(con, "lon_1")
y <- ncvar_get(con, "lat_1")
nc_close(con)
tb_data <- tibble(x = c(x), y = c(y), layer = c(layer))

# Create a quick plot using Tiles with approximate sizes around each coordinate-pair
map_output <- ggplot(tb_data) +
  geom_tile(aes(x, y, fill = layer, width = 0.018, height = 0.011)) +
  theme_bw() +
  borders("world", xlim = range(tb_data$x), ylim = range(tb_data$y), colour = "white") +
  coord_fixed(xlim = range(tb_data$x), ylim = range(tb_data$y)) +
  ggtitle(paste0(field, "-Field")) +
  labs(fill = field) +
  scale_fill_viridis_c() +
  xlab("Longitude [East]") +
  ylab("Latitude [North]") +
  theme(text = element_text(size = 18)) +
  coord_quickmap(xlim = range(tb_data$x), ylim = range(tb_data$y))

# Save Plot
ggsave(paste0(field, ".png"), height = 10, width = 16)

map_output
