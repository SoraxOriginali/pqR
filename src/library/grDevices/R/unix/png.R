#  File src/library/grDevices/R/unix/png.R
#  Part of the R package, http://www.R-project.org
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  A copy of the GNU General Public License is available at
#  http://www.r-project.org/Licenses/

.geometry <- function(width, height, units, res)
{
    units <- match.arg(units, c("in", "px", "cm", "mm"))
    if(units != "px" && is.na(res))
        stop("'res' must be specified unless 'units = \"px\"'")
    width <- switch(units,
                    "in" = res,
                    "cm" = res/2.54,
                    "mm" = res/25.4,
                    "px" = 1) * width
    height <- switch(units,
                     "in" = res,
                     "cm" = res/2.54,
                     "mm" = res/25.4,
                     "px" = 1) * height
    list(width = width, height = height)
}

png <- function(filename = "Rplot%03d.png",
                width = 480, height = 480, units = "px",
                pointsize = 12, bg = "white", res = NA, ...,
                type = c("cairo", "cairo-png", "Xlib", "quartz"), antialias)
{
    if(!checkIntFormat(filename)) stop("invalid 'filename'")
    g <- .geometry(width, height, units, res)
    new <- list(...)
    if(missing(type)) type <- getOption("bitmapType")
    type <- match.arg(type)
    if(!missing(antialias)) new$antialias <- match.arg(antialias, aa.cairo)
    d <- check.options(new, name.opt = ".X11.Options", envir = .X11env)
    antialias <- match(d$antialias, aa.cairo)
    if(type == "quartz" && capabilities("aqua")) {
        width <- g$width/ifelse(is.na(res), 72, res);
        height <- g$height/ifelse(is.na(res), 72, res);
        invisible(.External(CQuartz, "png", path.expand(filename),
                            width, height, pointsize, d$family,
                            antialias != 2L, TRUE, "", bg,
                            "white", if(is.na(res)) NULL else res))
    } else if (type == "cairo" && capabilities("cairo"))
        invisible(.External(devCairo, filename, 2L, g$width, g$height,
                            pointsize, bg, res, antialias, 100L, d$family))
    else if (type == "cairo-png" && capabilities("cairo"))
        invisible(.External(devCairo, filename, 5L, g$width, g$height,
                            pointsize, bg, res, antialias, 100L, d$family))
    else
        .Internal(X11(paste("png::", filename, sep=""),
                      g$width, g$height, pointsize, d$gamma,
                      d$colortype, d$maxcubesize, bg, bg, d$fonts, res,
                      0L, 0L, "", 0, 0, d$family))
}

jpeg <- function(filename = "Rplot%03d.jpeg",
                 width = 480, height = 480, units = "px",
                 pointsize = 12, quality = 75,
                 bg = "white", res = NA, ...,
                 type = c("cairo", "Xlib", "quartz"), antialias)
{
    if(!checkIntFormat(filename)) stop("invalid 'filename'")
    g <- .geometry(width, height, units, res)
    new <- list(...)
    if(!missing(type)) new$type <- match.arg(type)
    if(!missing(antialias)) new$antialias <- match.arg(antialias, aa.cairo)
    d <- check.options(new, name.opt = ".X11.Options", envir = .X11env)
    if(type == "quartz" && capabilities("aqua")) {
        width <- g$width/ifelse(is.na(res), 72, res);
        height <- g$height/ifelse(is.na(res), 72, res);
        invisible(.External(CQuartz, "jpeg", path.expand(filename),
                            width, height, pointsize, d$family,
                            antialias != 2L, TRUE, "", bg,
                            "white", if(is.na(res)) NULL else res))
    } else if (type == "cairo" && capabilities("cairo"))
        invisible(.External(devCairo, filename, 3L, g$width, g$height,
                            pointsize, bg, res, match(d$antialias, aa.cairo),
                            quality, d$family))
    else
        .Internal(X11(paste("jpeg::", quality, ":", filename, sep=""),
                      g$width, g$height, pointsize, d$gamma,
                      d$colortype, d$maxcubesize, bg, bg, d$fonts, res,
                      0L, 0L, "", 0, 0, d$family))
}

tiff <- function(filename = "Rplot%03d.tiff",
                 width = 480, height = 480, units = "px", pointsize = 12,
                 compression = c("none", "rle", "lzw", "jpeg", "zip"),
                 bg = "white", res = NA, ...,
                 type = c("cairo", "Xlib", "quartz"), antialias)
{
    if(!checkIntFormat(filename)) stop("invalid 'filename'")
    g <- .geometry(width, height, units, res)
    new <- list(...)
    type <- if(!missing(type)) match.arg(type) else getOption("bitmapType")
    if(!missing(antialias)) new$antialias <- match.arg(antialias, aa.cairo)
    d <- check.options(new, name.opt = ".X11.Options", envir = .X11env)
    comp <- switch( match.arg(compression),
                   "none" = 1, "rle" = 2, "lzw" = 5, "jpeg" = 7, "zip" = 8)
    if(type == "quartz" && capabilities("aqua")) {
        width <- g$width/ifelse(is.na(res), 72, res);
        height <- g$height/ifelse(is.na(res), 72, res);
        invisible(.External(CQuartz, "tiff", path.expand(filename),
                            width, height, pointsize, d$family,
                            antialias != 2L, TRUE, "", bg,
                            "white", if(is.na(res)) NULL else res))
    } else if (type == "cairo" && capabilities("cairo"))
        invisible(.External(devCairo, filename, 8L, g$width, g$height,
                            pointsize, bg, res, match(d$antialias, aa.cairo),
                            comp, d$family))
    else
        .Internal(X11(paste("tiff::", comp, ":", filename, sep=""),
                      g$width, g$height, pointsize, d$gamma,
                      d$colortype, d$maxcubesize, bg, bg, d$fonts, res,
                      0L, 0L, "", 0, 0, d$family))
}

bmp <- function(filename = "Rplot%03d.bmp",
                width = 480, height = 480, units = "px", pointsize = 12,
                bg = "white", res = NA, ...,
                type = c("cairo", "Xlib", "quartz"), antialias)
{
    if(!checkIntFormat(filename)) stop("invalid 'filename'")
    g <- .geometry(width, height, units, res)
    new <- list(...)
    type <- if(!missing(type)) match.arg(type) else getOption("bitmapType")
    if(!missing(antialias)) new$antialias <- match.arg(antialias, aa.cairo)
    d <- check.options(new, name.opt = ".X11.Options", envir = .X11env)
    if(type == "quartz" && capabilities("aqua")) {
        width <- g$width/ifelse(is.na(res), 72, res);
        height <- g$height/ifelse(is.na(res), 72, res);
        invisible(.External(CQuartz, "bmp", path.expand(filename),
                            width, height, pointsize, d$family,
                            antialias != 2L, TRUE, "", bg,
                            "white", if(is.na(res)) NULL else res))
    } else if (type == "cairo" && capabilities("cairo"))
        invisible(.External(devCairo, filename, 9L, g$width, g$height,
                            pointsize, bg, res, match(d$antialias, aa.cairo),
                            100L, d$family))
    else
        .Internal(X11(paste("bmp::", filename, sep=""),
                      g$width, g$height, pointsize, d$gamma,
                      d$colortype, d$maxcubesize, bg, bg, d$fonts, res,
                      0L, 0L, "", 0, 0, d$family))
}
