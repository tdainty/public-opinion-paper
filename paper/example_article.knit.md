---
output: 
  pdf_document:
    citation_package: natbib
    keep_tex: false
    fig_caption: true
    latex_engine: pdflatex
    template: svm-latex-ms2.tex
title: "An Example Article"
thanks: "The paper's revision history and the materials needed to reproduce its analyses can be found [on Github here](http://github.com/tdainty/example_article). Corresponding author: [thomas-dainty@uiowa.edu](mailto:thomas-dainty@uiowa.edu). Current version: December 18, 2024."
author:
- name: Thomas Dainty
  affiliation: University of Iowa
abstract: "Here's where you write 100 to 250 words, depending on the journal, that describe your objective, methods, results, and conclusion."
keywords: "these, always seem silly, to me, given google, but regardless"
date: "December 18, 2024"
fontsize: 11pt
spacing: single
bibliography: \dummy{}
biblio-style: apsr
citecolor: black
linkcolor: black
endnote: no
---



# Introduction to RMarkdown

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:


``` r
summary(mtcars)
```

```
##       mpg             cyl             disp             hp       
##  Min.   :10.40   Min.   :4.000   Min.   : 71.1   Min.   : 52.0  
##  1st Qu.:15.43   1st Qu.:4.000   1st Qu.:120.8   1st Qu.: 96.5  
##  Median :19.20   Median :6.000   Median :196.3   Median :123.0  
##  Mean   :20.09   Mean   :6.188   Mean   :230.7   Mean   :146.7  
##  3rd Qu.:22.80   3rd Qu.:8.000   3rd Qu.:326.0   3rd Qu.:180.0  
##  Max.   :33.90   Max.   :8.000   Max.   :472.0   Max.   :335.0  
##       drat             wt             qsec             vs        
##  Min.   :2.760   Min.   :1.513   Min.   :14.50   Min.   :0.0000  
##  1st Qu.:3.080   1st Qu.:2.581   1st Qu.:16.89   1st Qu.:0.0000  
##  Median :3.695   Median :3.325   Median :17.71   Median :0.0000  
##  Mean   :3.597   Mean   :3.217   Mean   :17.85   Mean   :0.4375  
##  3rd Qu.:3.920   3rd Qu.:3.610   3rd Qu.:18.90   3rd Qu.:1.0000  
##  Max.   :4.930   Max.   :5.424   Max.   :22.90   Max.   :1.0000  
##        am              gear            carb      
##  Min.   :0.0000   Min.   :3.000   Min.   :1.000  
##  1st Qu.:0.0000   1st Qu.:3.000   1st Qu.:2.000  
##  Median :0.0000   Median :4.000   Median :2.000  
##  Mean   :0.4062   Mean   :3.688   Mean   :2.812  
##  3rd Qu.:1.0000   3rd Qu.:4.000   3rd Qu.:4.000  
##  Max.   :1.0000   Max.   :5.000   Max.   :8.000
```

---
# This is a comment, set off with --- and started with #.  Comments are good for notes to self that you don't want to show up in the output.  Below is LaTeX code for a page break.
---
# test

---
\pagebreak 
## Including Plots

You can also embed plots, for example:

![\label{fig:dotwhisker_plot}Dot-and-Whisker Plot Example](example_article_files/figure-latex/dotwhisker_plot-1.pdf) 

Figure \ref{fig:dotwhisker_plot} is a plot made using the \texttt{dotwhisker} package [@Solt2015c]. Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.

## Citations
Want to cite something?

1. Find your cite key in your bib file.
1. Put an @ before it, like @Solt2017, or whatever it is
1. @Solt2017 creates an in-text citation
1. [@Herndon2014] creates a parenthetical citation

As @Gelman2014 note, the garden of forking paths can pose problems for researchers even when they are acting in good faith.

## Other Common Things

> This will create a block quote, if you want one.

Dropping a footnote is easy.^[See? Not hard at all.]

