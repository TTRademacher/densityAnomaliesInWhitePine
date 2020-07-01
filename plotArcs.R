#========================================================================================
# Script to plot arc of density anomaly
#----------------------------------------------------------------------------------------

# Load Dependencies
#----------------------------------------------------------------------------------------
library ('ggplot2')

# Download and read the data
#----------------------------------------------------------------------------------------
source ('readGrowthData.R')

# Load colour scheme for at reast height, near a branch whorl and in the 2010 section
#----------------------------------------------------------------------------------------
source ('plotingFunctions.R')

# Wrangle data to get average and sd deviation of arc by year
#----------------------------------------------------------------------------------------
yearlyData <- data %>% filter (Year < 2019) %>% group_by (Year) %>% 
  summarise (meanArcBH = mean (ArcBH, na.rm = TRUE),
             seArcBH   = se   (ArcBH),
             meanArc2010 = mean (Arc2010, na.rm = TRUE),
             seArc2010   = se   (Arc2010))

# Plot arc by year
#----------------------------------------------------------------------------------------
par (mar = c (5, 5, 1, 1))
plot (x = yearlyData [['Year']], y = yearlyData [['meanArcBH']], las = 1,
      xlab = 'Year', ylab = expression (paste ('arc (', degree,')')), ylim = c (0, 380),
      col = colours [1], pch = 19)
arrows (x0 = yearlyData [['Year']], 
        y0 = yearlyData [['meanArcBH']] - yearlyData [['seArcBH']],
        y1 = yearlyData [['meanArcBH']] + yearlyData [['seArcBH']], angle = 90, 
        length = 0.05, code = 3, col = colours [1])
points (x = yearlyData [['Year']], y = yearlyData [['meanArc2010']], 
        col = colours [3], pch = 19)
arrows (x0 = yearlyData [['Year']], 
        y0 = yearlyData [['meanArc2010']] - yearlyData [['seArc2010']],
        y1 = yearlyData [['meanArc2010']] + yearlyData [['seArc2010']], angle = 90, 
        length = 0.05, code = 3, col = colours [3])

# Test for effect of year on arc of density anomaly
#----------------------------------------------------------------------------------------
modYearBH <- lm (ArcBH ~ Year, data = data)
summary (modYearBH)
anova (modYearBH)
modYear2010 <- lm (Arc2010 ~ Year, data = data)
summary (modYear2010)
anova (modYear2010)

# Wrangle data to get average and standard deviation of arc by tree
#----------------------------------------------------------------------------------------
treeData <- data %>% filter (Year < 2019) %>% group_by (TreeID) %>% 
  summarise (meanArcBH = mean (ArcBH, na.rm = TRUE),
             seArcBH   = se   (ArcBH),
             meanArc2010 = mean (Arc2010, na.rm = TRUE),
             seArc2010   = se   (Arc2010))

# Plot arc by tree
#----------------------------------------------------------------------------------------
par (mar = c (5, 5, 1, 1))
plot (x = treeData [['TreeID']], y = treeData [['meanArcBH']], las = 1,
      xlab = 'Tree', ylab = expression (paste ('arc (', degree,')')), ylim = c (0, 380),
      col = colours [1], pch = 19)
arrows (x0 = treeData [['TreeID']], 
        y0 = treeData [['meanArcBH']] - treeData [['seArcBH']],
        y1 = treeData [['meanArcBH']] + treeData [['seArcBH']], angle = 90, 
        length = 0.05, code = 3, col = colours [1])
points (x = treeData [['TreeID']], y = treeData [['meanArc2010']], 
        col = colours [3], pch = 19)
arrows (x0 = treeData [['TreeID']], 
        y0 = treeData [['meanArc2010']] - treeData [['seArc2010']],
        y1 = treeData [['meanArc2010']] + treeData [['seArc2010']], angle = 90, 
        length = 0.05, code = 3, col = colours [3])

# Test for effect of year on arc of density anomaly
#----------------------------------------------------------------------------------------
modTreeBH <- lm (ArcBH ~ TreeID, data = data)
summary (modTreeBH)
anova (modTreeBH)
modTree2010 <- lm (Arc2010 ~ TreeID, data = data)
summary (modTree2010)
anova (modTree2010)

# Wrangle data to get average and standard deviation of arc by wood age
#----------------------------------------------------------------------------------------
temp1 <- data %>% filter (Year < 2019) %>% filter (MDABH1 == 1 | MDABH2 == 1) %>% 
  mutate (WoodAge = WoodAgeBH, Arc = ArcBH) 
temp2 <- data %>% filter (Year < 2019) %>% filter (MDA2010_1 == 1 | MDA2010_2 == 1) %>% 
  mutate (WoodAge = WoodAge2010, Arc = Arc2010)
temp <- rbind (temp1, temp2); rm (temp1, temp2)
woodAgeData <- temp %>% group_by (WoodAge) %>% 
  summarise (meanArc = mean (Arc, na.rm = TRUE),
             seArc = se (Arc))
  
# Plot arc by tree
#----------------------------------------------------------------------------------------
par (mar = c (5, 5, 1, 1))
plot (x = woodAgeData [['WoodAge']], y = woodAgeData [['meanArc']], las = 1,
      xlab = 'Wood age (years)', ylab = expression (paste ('arc (', degree,')')), ylim = c (0, 380),
      col = '#FFA500', pch = 19)
arrows (x0 = woodAgeData [['WoodAge']], 
        y0 = woodAgeData [['meanArc']] - woodAgeData [['seArc']],
        y1 = woodAgeData [['meanArc']] + woodAgeData [['seArc']], angle = 90, 
        length = 0.05, code = 3, col = '#FFA500')

# Test for effect of wood age on arc of density anomaly 
#----------------------------------------------------------------------------------------
modWoodAge <- lm (Arc ~ WoodAge, data = temp); rm (temp)
summary (modWoodAge)
anova (modWoodAge)
abline (modWoodAge, col = '#FFA500', lwd = 2, lty = 2)

# Wrangle data to get average and standard deviation of arc by ring width
#----------------------------------------------------------------------------------------
temp1 <- data %>% filter (Year < 2019) %>% filter (MDABH1 == 1) %>% 
  mutate (RingWidth = RingWidthBH1, Arc = ArcBH) 
temp2 <- data %>% filter (Year < 2019) %>% filter (MDABH2 == 1) %>% 
  mutate (RingWidth = RingWidthBH2, Arc = ArcBH) 
temp3 <- data %>% filter (Year < 2019) %>% filter (MDA2010_1 == 1) %>% 
  mutate (RingWidth = RingWidth2010_1, Arc = Arc2010)
temp4 <- data %>% filter (Year < 2019) %>% filter (MDA2010_2 == 1) %>% 
  mutate (RingWidth = RingWidth2010_2, Arc = Arc2010) 
temp <- rbind (temp1, temp2, temp3, temp4); rm (temp1, temp2, temp3, temp4)

# Plot arc by tree
#----------------------------------------------------------------------------------------
par (mar = c (5, 5, 1, 1))
plot (x = temp [['RingWidth']], y = temp [['Arc']], las = 1,
      xlab = 'Ring width (mm)', ylab = expression (paste ('arc (', degree,')')), ylim = c (0, 380),
      col = '#FFA500', pch = 19)

# Test for effect of wood age on arc of density anomaly 
#----------------------------------------------------------------------------------------
modRingWidth <- lm (Arc ~ RingWidth, data = temp); rm (temp)
summary (modRingWidth)
anova (modRingWidth)
abline (modRingWidth, col = '#FFA500', lwd = 2, lty = 2)
#========================================================================================