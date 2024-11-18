"Setting up RMarkdown as per Solt's Blog Discussion"
install.packages("tinytex")
tinytex::install_tinytex()

"Setting up Stata to run in R if necessary"

if (!require(RStata)) install.packages("RStata"); library(RStata) # this will install RStata if not already installed

stata("my_do_file.do", 
      stata.path = "/Applications/Stata/StataMP.app/Contents/MacOS/stata-mp", # yours probably differs: use the chooseStataBin() command on windows or linux machines; on Macs, right click on the Stata app, select "Show Package Contents", then see what's in the Contents/MacOS/ directory
      stata.version = 13)  # again, specify what _you_ have

library(usethis)

usethis::edit_r_environ()