# Title: global.R
# Purpose: load pkgs and functions

# Load packages----
if (!require("pacman")) install.packages("pacman")
library(pacman)

pacman::p_load(
  dplyr,
  shiny,
  ggplot2,
  shinyFeedback, # warning labels
  scales #for formatting plot labels
)

# Function to compute restricted cubic spline terms manually
spline_calc <- function(x, k1, k2, k3) {
  norm <- (k3 - k1)^(2 / 3)
  term1 <- (pmax((x - k1) / norm, 0))^3
  term2 <- ((k3 - k1) / (k3 - k2)) * ((pmax((x - k2) / norm, 0))^3)
  term3 <- ((k2 - k1) / (k3 - k2)) * ((pmax((x - k3) / norm, 0))^3)
  return(term1 - term2 + term3)
}

# Function to compute Prognostic Index (PI) and survival probability at 365 days
riskcalc <- function(FirstRegYear,
                     FAge,
                     duryrsWin,
                     BMIWin,
                     FSecInf,
                     EverSmoke,
                     EverAlc,
                     spermdx,
                     endometdx,
                     ovulatory,
                     Unexplained,
                     Tubal,
                     other) {
  # Compute manually-defined restricted cubic spline (rcs) terms
  rcsFirstYr <- spline_calc(FirstRegYear, 1999, 2008, 2014)
  rcsFAge <- spline_calc(FAge, 25, 32, 39)
  rcsduryrs <- spline_calc(duryrsWin, 1, 2, 5)
  rcsBMI <- spline_calc(BMIWin, 20.077, 24.61, 34.29)
  
  # Compute Prognostic Index (PI)
  # means
  centreFirstRegYear <- 2007.17583968388
  centrercsFirstYr <- 4.74761156584
  centreFAge <- 32.25839683884
  centrercsFAge <- 3.88503775769
  centreduryrsWin <- 2.43947690281
  centrercsduryrs  <- 0.46440767115
  centreBMIWin <- 25.98881718318
  centrercsBMI <- 2.26049036821
  centreFSecInf <- 0.44117273497
  centreEverSmoke <- 0.22518346034
  centreEverAlc <- 0.75131950325
  centrespermdx <- 0.30741955970
  centreendometdx <- 0.04639429862
  centreovulatory <- 0.25503810330
  centreUnexplained <- 0.25457239627
  centreTubal <- 0.17867273497
  centreother <- 0.08125176404
  
  # PI
  PI <- (
    -0.033862612246  * (FirstRegYear - centreFirstRegYear)
    + 0.046143448439  * (rcsFirstYr - centrercsFirstYr)
    + 0.006882384723  * (FAge - centreFAge)
    - 0.087863170098  * (rcsFAge - centrercsFAge)
    - 0.355503401057  * (duryrsWin - centreduryrsWin)
    + 0.371905469122  * (rcsduryrs - centrercsduryrs)
    - 0.026164440894  * (BMIWin - centreBMIWin)
    + 0.019582306401  * (rcsBMI - centrercsBMI)
    + 0.243226040700  * (FSecInf - centreFSecInf)
    - 0.269462732016  * (EverSmoke - centreEverSmoke)
    + 0.054441659348  * (EverAlc - centreEverAlc)
    - 0.315062921906  * (spermdx - centrespermdx)
    - 0.222606714511  * (endometdx - centreendometdx)
    - 0.129747447995  * (ovulatory - centreovulatory)
    + 0.301118223884  * (Unexplained - centreUnexplained)
    - 0.442858096828  * (Tubal - centreTubal)
    - 0.339330210440  * (other - centreother)
  )
  
  # Survival probability at 365 days
  #adjust for shrinkage given subgroups of Endometriosis and Other have lower calibration slope
  #replace_when stops when first condition is true
  PI_shrinkage <- PI
  if (endometdx == 1) {
    PI_shrinkage <- PI * 0.59
  } else if (other == 1) {
    PI_shrinkage <- PI * 0.60
  }
  
  risk_365 <- 1 - (0.8776930515^(exp(PI_shrinkage)))
  return(round(risk_365, 3))
}