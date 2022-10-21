# DCR2021_ML_PubPol

#### Dec 8th
#### Instructor: Jonathan Hersh (hersh@chapman.edu)

## Getting Started

Hello! These are the materials for the Dec 8th R and Machine Learning training. The topics covered will include:

|               | **Monday, October 24<sup>th</sup>, 2022**                                      |
| ------------- | ------------------------------------------------------------------------------ |
| Time          | Topic                                                                          |
| 8:30 AM       | Registration and light breakfast                                               |
| 9:00 AM       | Opening remarks – Maria Cecilia Deza (IDB)                                     |
| 9:10 AM       | Introductions, participants and instructor Jonathan Hersh (Chapman University) |
| 9:30 AM.    | 1\. Introduction to R                                                          |
| 11:00 AM      | _Lunch_                                                                        |
| 1:00 PM       | 2\. Graphing relationships between variables using ggplot2                     |
| 4:00 PM       | _Coffee break_                                                                 |
| 4:15 PM       | 3\. Machine Learning overview: introduction to prediction methods              |
| 5:30 PM       | Recap of the day, Q&A                                                          |

------

## Computing and Installation Instructions

We will be coding in the R together. I don't presume **any** knowledge of coding, so don't be afraid if you've never coded before. 

There are two ways you can run R and [RStudio](https://rstudio.com/), either locally on your computer, or on the cloud in [rstudio.cloud](rstudio.cloud)

### Installing R Locally

If you would like to install and run R locally please install the following programs:

* RStudio Desktop 2021.09.1+372 [link](https://www.rstudio.com/products/rstudio/download/#download)
* R 4.2.1 [link](https://cran.r-project.org/bin/windows/base/)

### Running R in a Web Browser

If you cannot install those programs, please head over to [rstudio.cloud](https://rstudio.cloud). 

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

```
install.packages('usethis')
install.packages('tidyverse')

newProject <- usethis::use_course('https://github.com/jonhersh/DCR2021_ML_PubPol/archive/main.zip')
```
