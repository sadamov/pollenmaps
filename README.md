# Pollenmaps
This project shows some examples on how to plot pretty maps in R with the latest packages. 
It displays the power of R to create modern looking maps with a clean look that are highly customisable.
Currently, it functions as a loose collection of open-source and third-party map material combined with various raster and shapefiles. 
I would already like to mention that the most beautiful map was taken from here: https://timogrossenbacher.ch/2019/04/bivariate-maps-with-ggplot2-and-sf/

## Setup
The environment.yml shows the conda environment that I was using to run the code in.
To steup the same conda env run `conda env create -f environment.yml`
It should also be possible to run the code with the existing packages on Tsa (CSCS @ ETH).
The following system libraries (modules on tsa) were installed and loaded in my session (via Spack or Easybuild) as some R-packages depend on them:
<pre>
 1) slurm/20.02.5                    19) r/3.5.2-foss-2019b                
 2) bzip2/.1.0.8                     20) pandoc/2.10                       
 3) ncurses/.6.1                     21) libpng/1.6.37-gcccore-8.3.0       
 4) libreadline/.8.0                 22) expat/.2.2.5                  
 5) python/3.7.4                     23) udunits/2.2.26                
 6) EasyBuild/4.3.1                  24) geos/3.7.2-foss-2019b         
 7) EasyBuild-custom/cscs            25) proj/6.1.1-foss-2019b     
 8) gcccore/.8.3.0                   26) gdal/3.0.1-foss-2019b
 9) zlib/.1.2.11-gcccore-8.3.0       27) curl/.7.65.1-foss-2019b
1)  binutils/.2.32-gcccore-8.3.0     28) szip/.2.1.1-gcccore-8.3.0
2)  gcc/8.3.0                        29) hdf5/1.10.5-gompi-2019b
3)  openmpi/4.0.2-gcc-8.3.0          30) netcdf/4.7.0-foss-2019b
4)  openblas/0.3.7-gcc-8.3.0         31) protobuf/3.7.1-gcccore-8.3.0
5)  gompi/.2019b                     32) gcccore/.6.4.0
6)  fftw/3.3.8-gompi-2019b           33) jq/1.5-gcccore-6.4.0
7)  scalapack/2.0.2-gompi-2019b      
8)  foss/.2019b                 
9)  PrgEnv-gnu/19.2-nocuda          
</pre>
  
The project uses renv to install and load all R-packages required for this analysis - run `renv::restore()` to install all required packages. 
This will load a broad selection of R-packages, feel free to only load a subselection of packages manually.

## Vignettes
- The analysis is conducted in the file called *pollenmaps.Rmd*, a R-Markdown vignette: https://bookdown.org/yihui/rmarkdown/r-package-vignette.html
- The R-script called *animation.R* renders a GIF animation for a whole series of NetCDF files (e.g. one Pollen-Season)
- The R-script called *simple_map.R* returns a quick tile map based on the ggplot-package

## Input
Historically, netCDF files and arrays with lat/long information are widely used in atmospheric science, hence these types shall function as input files.

- *c1_pollen_muni.csv* is a cosmo-1 model output with hourly grass pollen concentrations retrieved at the geo-location of all Swiss municipalities at 2020-07-01 00h. The coordinates of all Municipalities were retrieved using the google Geocoding API and stored in my location list (happy to share it). Then Fieldextra retrieves the requested variable, in my case grass pollen (Poaceae), as defined in the *pollen.nl* namelist.
- The remaining shapefiles were pulled from https://timogrossenbacher.ch/2019/04/bivariate-maps-with-ggplot2-and-sf/ and represent a variety of opensource maps for Switzerland.
- In the vignette the path to a netCDF-file is defined: Currently this points to a cosmo-1 model output with daily pollen concentrations retrieved for all grid-boxes in the Cosmo-1 Domain at 2020-07-01 00h.

## Output
To output all or a selection of the plots in the main vignette, the user can either execute individual code chunks or *knit* the whole vignette to create an html file.
`rmarkdown::render("pollenmaps.Rmd", encoding = "UTF-8")`
