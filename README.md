# Kobe plot of fishery status by country over time

![](animation.gif)

# About
Produces a bubble chart of fisheries status over time by country using historical data from the capture fisheries database documented in Costello, C., Ovando, D., Clavelle, T., Strauss, C. K., Hilborn, R., Melnychuk, M. C., ... & Leland, A. (2016). Global fishery prospects under contrasting management regimes. Proceedings of the national academy of sciences, 113(18), 5125-5129.

# How to use
Simply run 'fisheriesOverTime.R' after obtaining the packages loaded at the beginning of the script and placing the data used with the script ('ProjectionData.csv'; obtainable seperately below) in the working directory.

# Obtaining the data used with the script
The version of the database used can be obtained from https://datadryad.org/stash/dataset/doi:10.25349/D96G6H. This was the version uploaded for use with a subsequent paper rather than Costello et al. 2016 above. The file required from the repository is 'ProjectionData.csv'.

# Current limitations
- Rows with any missing data in any of the key columns ('BvBmsy', 'FvFmsy', and 'Catch') are excluded from the animation entirely. If this is correlated with fisheries with certain characteristics then it may introduce a systematic skew in the animation
- A small number countries/classifications that are present in the data are excluded from the final animation because the `countryname()` functions fails to parse them into ISO-2 character codes
  - Even if one manually classified the above countries/classifications, most would not have any image assigned to them by the `geom_flag()` function
- Each fishery's contribution to mean B/B_MSY and F/F_MSY is not weighted by fishery size, which would perhaps produce a more informative figure
