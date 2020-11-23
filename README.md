# Pollenmaps
This project shows some examples on how to plot pretty maps in R with the latest packages. 
It displays the power of R to create modern looking maps with a clean look that are highly customisable.
Currently, it functions as a loose collection of open-source and third-party map material combined with various raster and shapefiles. 
I would already like to mention that the most beautiful map was taken from here: https://timogrossenbacher.ch/2019/04/bivariate-maps-with-ggplot2-and-sf/

## Setup
Generally, all code chunks in this vignette need to run in tsa with the current R-version 3.5.2 (2020-11-20).
I access Tsa@CSCS via VSCode and remote-ssh. Then I run an interactive R sessions while working in the vignette. This required quite a few steps to set it up properly. 
I plan to write a wiki page about vscode-R @ cscs at some point in the future. Feel free to ask me anything in the meantime.
The main vignette loads a broad selection of R-packages, feel free to only load a subselection of them when executing individual code chunks.

The following system libraries (modules) should be installed and loaded (via Spack or Easybuild) as some R-packages depend on them:
`module load PrgEnv-gnu/19.2-nocuda`
`module load r pandoc libpng udunits gdal netcdf protobuf jq v8`

## Input
Historically, netCDF files and arrays with latlong information are widely used in atmospheric science, hence these types shall function as input files.

- *c1e_pollen_muni.csv* is a cosmo-1E model output with hourly grass pollen concentrations retrieved at the geo-location of all Swiss municipalities at 2020-07-01 00h. 
The coordinates of all Municipalities were retrieved using the google Geocoding API and stored and my location list (happy to share it).
- *c1e_pollen_grid.csv* is a cosmo-1E model output with daily pollen concentrations retrieved for all grid-boxes in the Cosmo-1E Domain at 2020-07-01 00h.
- The remaining shapefiles were pulled from https://timogrossenbacher.ch/2019/04/bivariate-maps-with-ggplot2-and-sf/ and represent a variety of maps for Switzerland.

## Output
To output all or a selection of the plots in the main vignette, the user can either execute individual code chunks or *knit* the whole vignette to create an html file.
