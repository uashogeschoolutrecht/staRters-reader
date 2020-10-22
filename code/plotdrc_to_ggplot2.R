#' Plot a drc plot to a ggplot2 plot
#'
#'
#'
#' @export

plotdrc_to_ggplot2 <-
  function (x, ..., add = FALSE, level = NULL, type = c("average",
                "all", "bars", "none", "obs", "confidence"), broken = FALSE,
                bp, bcontrol = NULL, conName = NULL, axes = TRUE, gridsize = 100,
                log = "x", xtsty, xttrim = TRUE, xt = NULL, xtlab = NULL,
                xlab, xlim, yt = NULL, ytlab = NULL, ylab, ylim, cex, cex.axis = 1,
                col = FALSE, lty, pch, legend, legendText, legendPos, cex.legend = 1,
                normal = FALSE, normRef = 1, confidence.level = 0.95, plot_title = NULL) {
  object <- x
  type <- match.arg(type)
  if ((log == "") || (log == "y")) {
    logX <- FALSE
  }
  else {
    logX <- TRUE
  }
  if (missing(xtsty)) {
    if (logX) {
      xtsty <- "base10"
    }
    else {
      xtsty <- "standard"
    }
  }
  dataList <- object[["dataList"]]
  dose <- dataList[["dose"]]
  resp <- dataList[["origResp"]]
  curveid <- dataList[["curveid"]]
  plotid <- dataList[["plotid"]]
  if (normal) {
    respList <- split(resp, curveid)
    resp <- unlist(mapply(normalizeLU, respList, as.list(as.data.frame(getLU(object))),
                          normRef = normRef))
  }
  if (!is.null(plotid)) {
    assayNoOld <- as.vector(plotid)
  }
  else {
    assayNoOld <- as.vector(curveid)
  }
  uniAss <- unique(assayNoOld)
  numAss <- length(uniAss)
  doPlot <- is.null(level) || any(uniAss %in% level)
  if (!doPlot) {
    stop("Nothing to plot")
  }
  plotFct <- (object$curve)[[1]]
  logDose <- (object$curve)[[2]]
  naPlot <- ifelse(is.null(object$curve$naPlot), FALSE, TRUE)
  dlNames <- dataList[["names"]]
  doseName <- dlNames[["dName"]]
  respName <- dlNames[["orName"]]
  if (missing(xlab)) {
    if (doseName == "") {
      xlab <- "Dose"
    }
    else {
      xlab <- doseName
    }
  }
  if (missing(ylab)) {
    if (respName == "") {
      ylab <- "Response"
    }
    else {
      ylab <- respName
    }
  }
  if (missing(xlim)) {
    xLimits <- c(min(dose), max(dose))
  }
  else {
    xLimits <- xlim
  }
  if (missing(bp)) {
    if (!is.null(logDose)) {
      conLevel <- round(min(dose[is.finite(dose)])) - 1
    }
    else {
      log10cl <- round(log10(min(dose[dose > 0]))) - 1
      conLevel <- 10^(log10cl)
    }
  }
  else {
    conLevel <- bp
  }
  if ((xLimits[1] < conLevel) && (logX || (!is.null(logDose)))) {
    xLimits[1] <- conLevel
    smallDoses <- (dose < conLevel)
    dose[smallDoses] <- conLevel
    if (is.null(conName)) {
      if (is.null(logDose)) {
        conName <- expression(0)
      }
      else {
        conName <- expression(-infinity)
      }
    }
  }
  else {
    conName <- NULL
  }
  if (xLimits[1] >= xLimits[2]) {
    stop("Argument 'conLevel' is set too high")
  }
  if ((is.null(logDose)) && (logX)) {
    dosePts <- exp(seq(log(xLimits[1]), log(xLimits[2]),
                       length = gridsize))
    dosePts[1] <- xLimits[1]
    dosePts[gridsize] <- xLimits[2]
  }
  else {
    dosePts <- seq(xLimits[1], xLimits[2], length = gridsize)
  }
  if (is.null(logDose)) {
    plotMat <- plotFct(dosePts)
  }
  else {
    plotMat <- plotFct(logDose^(dosePts))
  }
  if (normal) {
    respList <- split(resp, curveid)
    plotMat <- mapply(normalizeLU, as.list(as.data.frame(plotMat)),
                      as.list(as.data.frame(getLU(object))), normRef = normRef)
  }
  maxR <- max(resp)
  options(warn = -1)
  maxPM <- apply(plotMat, 2, max, na.rm = TRUE)
  if (max(maxPM) > maxR) {
    maxPM <- maxPM[which.max(maxPM)]
  }
  else {
    maxPM <- maxR
  }
  options(warn = 0)
  if (missing(ylim)) {
    if (missing(xlim)) {
      yLimits <- c(min(resp), maxPM)
    }
    else {
      yLimits <- drc:::getRange(dose, resp, xLimits)
    }
  }
  else {
    yLimits <- ylim
  }
  par(las = 1)
  if (!is.null(logDose)) {
    if (log == "x") {
      log <- ""
    }
    if ((log == "xy") || (log == "yx")) {
      log <- "y"
    }
  }
  eps1 <- 1e-08
  logVec <- !((dose < xLimits[1] - eps1) | (dose > xLimits[2] +
                                              eps1))
  dose <- dose[logVec]
  resp <- resp[logVec]
  assayNoOld <- assayNoOld[logVec]
  if (identical(type, "bars")) {
    predictMat <- predict(object, interval = "confidence",
                          level = confidence.level)[, c("Lower", "Upper")]
    barFct <- function(plotPoints) {
      pp3 <- plotPoints[, 3]
      pp4 <- plotPoints[, 4]
      plotCI(plotPoints[, 1], pp3 + 0.5 * (pp4 - pp3),
             li = pp3, ui = pp4, add = TRUE, pch = NA)
    }
    ciFct <- function(level, ...) {
      invisible(NULL)
    }
    pointFct <- function(plotPoints, cexVal, colVal, pchVal,
                         ...) {
      invisible(NULL)
    }
  }
  else if (identical(type, "confidence")) {
    barFct <- function(plotPoints) {
      invisible(NULL)
    }
    ciFct <- function(level, ...) {
      newdata <- data.frame(DOSE = dosePts, CURVE = rep(level,
                                                        length(dosePts)))
      predictMat <- predict(object, newdata = newdata,
                            interval = "confidence", level = confidence.level)
      x <- c(dosePts, rev(dosePts))
      y <- c(predictMat[, "Lower"], rev(predictMat[, "Upper"]))
      polygon(x, y, border = NA, ...)
    }
    pointFct <- function(plotPoints, cexVal, colVal, pchVal,
                         ...) {
      invisible(NULL)
    }
  }
  else {
    barFct <- function(plotPoints) {
      invisible(NULL)
    }
    ciFct <- function(level, ...) {
      invisible(NULL)
    }
    pointFct <- function(plotPoints, cexVal, colVal, pchVal,
                         ...) {
      points(plotPoints, cex = cexVal, col = colVal, pch = pchVal,
             ...)
    }
  }
  if ((identical(type, "none")) || (identical(type, "bars"))) {
    plotType <- "n"
  }
  else {
    plotType <- "p"
  }
  if (is.null(level)) {
    level <- uniAss
  }
  else {
    level <- intersect(level, uniAss)
  }
  lenlev <- length(level)
  if (missing(legend)) {
    if (lenlev == 1) {
      legend <- FALSE
    }
    else {
      legend <- TRUE
    }
  }
  colourVec <- rep(1, lenlev)
  if (is.logical(col) && col) {
    colourVec <- 1:lenlev
  }
  if (!is.logical(col) && (length(col) == lenlev)) {
    colourVec <- col
  }
  if (!is.logical(col) && (!(length(col) == lenlev))) {
    colourVec <- rep(col, lenlev)
  }
  cexVec <- drc:::parFct(cex, lenlev, 1)
  ltyVec <- drc:::parFct(lty, lenlev)
  pchVec <- drc:::parFct(pch, lenlev)
  levelInd <- 1:lenlev
  for (i in levelInd) {
    indVec <- level[i] == assayNoOld
    plotPoints <- switch(type, average = cbind(as.numeric(names(tapVec <- tapply(resp[indVec],
                                                                                 dose[indVec], mean))), tapVec), bars = cbind(as.numeric(names(tapVec <- tapply(resp[indVec],
                                                                                                                                                                dose[indVec], mean))), tapVec, tapply(predictMat[indVec,
                                                                                                                                                                                                                 1], dose[indVec], head, 1), tapply(predictMat[indVec,
                                                                                                                                                                                                                                                               2], dose[indVec], head, 1)), none = cbind(dose[indVec],
                                                                                                                                                                                                                                                                                                         resp[indVec]), all = cbind(dose[indVec], resp[indVec]),
                         obs = cbind(dose[indVec], resp[indVec]))
    if ((!add) && (i == 1)) {
      plot(plotPoints, type = plotType, xlab = xlab, ylab = ylab,
           log = log, xlim = xLimits, ylim = yLimits, axes = FALSE,
           frame.plot = TRUE, col = colourVec[i], pch = pchVec[i],
           cex = cexVec[i], ...)
      barFct(plotPoints)
      ciFct(level = i, col = alpha(colourVec[i], 0.25))
      drc:::addAxes(axes, cex.axis, conName, xt, xtlab, xtsty,
              xttrim, logX, yt, ytlab, conLevel, logDose)
      ivMid <- drc:::brokenAxis(bcontrol, broken, conLevel, dosePts,
                          gridsize, log, logX, logDose)
    }
    else {
      ivMid <- drc:::brokenAxis(bcontrol, broken, conLevel, dosePts,
                          gridsize, log, logX, logDose, plotit = FALSE)
      if (!identical(type, "none")) {
        pointFct(plotPoints, cexVec[i], colourVec[i],
                 pchVec[i], ...)
        barFct(plotPoints)
        ciFct(level = i, col = alpha(colourVec[i], 0.25))
      }
    }
  }
  noPlot <- rep(FALSE, lenlev)
  if (!identical(type, "obs")) {
    for (i in levelInd) {
      indVal <- uniAss %in% level[i]
      if ((!naPlot) && (any(is.na(plotMat[, indVal])))) {
        noPlot[i] <- TRUE
        next
      }
      lines(dosePts[ivMid], plotMat[ivMid, indVal], lty = ltyVec[i],
            col = colourVec[i], ...)
    }
  }
  drc:::makeLegend(colourVec, legend, cex.legend, legendPos, legendText,
             lenlev, level, ltyVec, noPlot, pchVec, type, xLimits,
             yLimits)
  par(las = 0)
  retData <- data.frame(dosePts, as.data.frame(plotMat))
  colnames(retData) <- c(doseName, dlNames[["cNames"]])


result <- list(retData, plotPoints)


points <- as.data.frame(result[[2]])
drc.fit <- as.data.frame(result[[1]])
names(points) <- c("x", "y")
names(drc.fit) <- c("x", "y")

gg_plot <-
  ggplot2::ggplot(data=points, aes(x = x, y = y)) +
  geom_point() +
  geom_line(data=drc.fit, aes(x = x, y = y)) +
  scale_x_continuous(trans='log10', limits = xlim) +
  ylab(ylab) +
  xlab(xlab) +
  lims(y = ylim) +
  ggtitle(plot_title) +
  theme_bw()

return(as.list(gg_plot, retData))

 }





