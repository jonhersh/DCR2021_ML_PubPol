# DCR2021_ML_PubPol

#### Dec 8th
#### Instructor: Jonathan Hersh (hersh@chapman.edu)

## Getting Started

Hello! These are the materials for the Dec 8th R and Machine Learning training. The topics covered will include:

1. Intro to Machine Learning for Public Policy 
2. Intro to [Tidyverse](https://www.tidyverse.org/) for data manipulation
3. Regularized regression with Lasso, Ridge, and [ElasticNet](https://glmnet.stanford.edu/articles/glmnet.html)
4. Binary classification and diagnostics
5. Regression trees and random forests 
6. Communicating models in [Shiny](https://shiny.rstudio.com/) and [flexdashboard](https://pkgs.rstudio.com/flexdashboard/) 


------

## Computing and Installation Instructions

We will be coding in the R together. I don't presume **any** knowledge of coding, so don't be afraid if you've never coded before. 

There are two ways you can run R and [RStudio](https://rstudio.com/), either locally on your computer, or on the cloud in [rstudio.cloud](rstudio.cloud)

### Installing R Locally

If you would like to install and run R locally please install the following programs:

* RStudio Desktop 2021.09.1+372 [link](https://www.rstudio.com/products/rstudio/download/#download)
* R 4.1.1 [link](https://cran.r-project.org/bin/windows/base/)

### Running R in a Web Browser

If you cannot install those programs, please head over to [rstudio.cloud](rstudio.cloud). 

* Click "GET STARTED FOR FREE" 
* Then click "Sign Up". 
![](images/rstudio.cloud.PNG)
* You may log in using your email address
* Next click new project. 
* You should now see a R Studio session in your browser. 
![](images/rstudio_console.PNG)


### Using Github

If you have never used Github, don't worry. You can either clone the repository, or you may click the "Code" button on the main page, and then "Download Zip" to download all the files. You may also download the files individually, or copy and paste code as needed. 

### Loading Project in R

install.packages('usethis')
install.packages('tidyverse')

newProject <- usethis::use_course('https://github.com/jonhersh/DCR2021_ML_PubPol/archive/main.zip')

