# Literate Programming with RMarkdown {#rmarkdown}

_This chapter is best read in the source RMarkdown file_

## Credits:
https://nceas.github.io/sasap-training/materials/reproducible_research_in_r_fairbanks/index.html

## Introduction

Plain text is a great way to write information down. Plain text has some major advantages:

- Works regardless of what time you're trying to read the file, i.e. computers have and will continue to speak plain text
- Works perfectly with version control software like git. 
- Easy to read, easy to write

Markdown is a plain text format that allows for common typesetting features including:

- Text formatting (bold, italic, etc.)
- Links
- Tables
- In-line images

Without the need for spending time typesetting which is tedious and usually unnecessary. So if we want those kinds of things, we might want to use Markdown.

RMarkdown allows us to produce an output document (PDF, DOCX, website) based upon a mix of Markdown and R code.
This lets us write analyses in R as we already do but also write our reports/papers/etc. in R.
Instead of the usual loop:

- Run analysis
- Edit/update report
- Commit changes to Git-repository
- Push to Github

The loop becomes:

- Edit RMarkdown doc
- Commit changes to Git-repository
- Push to Github

This workflow fits in a 'continuous integration' workflow

...

## To get an example of paramterized RMarkdown:
Clone this repo and run the examples in the folder ~/work_flows/Rmd/
https://github.com/uashogeschoolutrecht/work_flows

To see an interactive Graph run the example:



## Good resources:

- [http://rmarkdown.rstudio.com/](http://rmarkdown.rstudio.com/)
- [http://kbroman.org/knitr_knutshell/](http://kbroman.org/knitr_knutshell/)

## Learning Outcomes

- Gain an awareness of Markdown and RMarkdown
- Author a simple RMarkdown document in RStudio

## RMarkdown Principles:

### Chunks

Chunks take options, see: https://yihui.name/knitr/options/

#### Echo and Include {-}

When writing a report, it's common to not want the R code to actually show up in the final document.
Use the `echo` chunk option to do this:
<img src="ch05-rmarkdown_files/figure-html/unnamed-chunk-1-1.png" width="672" />
or if you want the code to run but not show anything, use `include`



#### Eval {-}

Sometimes you may just want to show some R code with nice syntax highlighting but not evaluate it:


```r
will_it_eval <- "eval?"
```

#### Cache {-}

If you know a chunk will not need to change as other parts of the document are knitted, you can cache a chunk that contains a potentially long-running or slow command or commands:



```r
library(ggplot2)
ggplot(mpg, aes(displ, hwy, color = class)) + 
  geom_point() # Some really slow plot
```

<img src="ch05-rmarkdown_files/figure-html/unnamed-chunk-4-1.png" width="672" />

### Inline expressions in prose

You can include inline r-code in this way:

4

It evaluates to: 2 + 2 = 4

### Plots

Base graphics: Just run `plot(1:10)`
ggplot2: Run `ggplot(...))`

Customize output sizing with chunk options: `fig.width`, `fig.height`, `dpi`, `out.width`

### Tables

If you search around, there are tons of ways to do this. The most basic way and the way I almost always use is with the `kable` function from the `knitr` package:


```r
library(ggplot2)
data("mpg")
knitr::kable(head(mpg))
```



|manufacturer |model | displ| year| cyl|trans      |drv | cty| hwy|fl |class   |
|:------------|:-----|-----:|----:|---:|:----------|:---|---:|---:|:--|:-------|
|audi         |a4    |   1.8| 1999|   4|auto(l5)   |f   |  18|  29|p  |compact |
|audi         |a4    |   1.8| 1999|   4|manual(m5) |f   |  21|  29|p  |compact |
|audi         |a4    |   2.0| 2008|   4|manual(m6) |f   |  20|  31|p  |compact |
|audi         |a4    |   2.0| 2008|   4|auto(av)   |f   |  21|  30|p  |compact |
|audi         |a4    |   2.8| 1999|   6|auto(l5)   |f   |  16|  26|p  |compact |
|audi         |a4    |   2.8| 1999|   6|manual(m5) |f   |  18|  26|p  |compact |

or an interactive table

```r
library(ggplot2)
data("mpg")
DT::datatable(head(mpg))
```

<!--html_preserve--><div id="htmlwidget-9a855d59061b9784f022" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-9a855d59061b9784f022">{"x":{"filter":"none","data":[["1","2","3","4","5","6"],["audi","audi","audi","audi","audi","audi"],["a4","a4","a4","a4","a4","a4"],[1.8,1.8,2,2,2.8,2.8],[1999,1999,2008,2008,1999,1999],[4,4,4,4,6,6],["auto(l5)","manual(m5)","manual(m6)","auto(av)","auto(l5)","manual(m5)"],["f","f","f","f","f","f"],[18,21,20,21,16,18],[29,29,31,30,26,26],["p","p","p","p","p","p"],["compact","compact","compact","compact","compact","compact"]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>manufacturer<\/th>\n      <th>model<\/th>\n      <th>displ<\/th>\n      <th>year<\/th>\n      <th>cyl<\/th>\n      <th>trans<\/th>\n      <th>drv<\/th>\n      <th>cty<\/th>\n      <th>hwy<\/th>\n      <th>fl<\/th>\n      <th>class<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"columnDefs":[{"className":"dt-right","targets":[3,4,5,8,9]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

https://rmarkdown.rstudio.com/lesson-7.html

## Output formats

RMarkdown documents can be converted into many formats, most often:

- PDF
- HTML
- Microsoft Word
- ioslides
- beamer

See more info here: http://rmarkdown.rstudio.com/lesson-9.html

You can specifically choose which output format to render to with the RStudio "Knit" button in the toolbar, or with:

```
rmarkdown::render(...)
```

We can control which output format(s) knitting will produce and even customize the options for each format separately.
To customize each output format, change the YAML frontmatter:

e.g. customize HTML and PDF output

```
---
title: "My document"
output:
  html_document:
    toc: true
    toc_float: true
  pdf_document:
    fig_caption: false
---

```

## Summary

- Markdown is a simple plain text format suitable for authoring rich documents
- RMarkdown is a slight extention of the Markdown syntax that lets us mix code and prose together
- RMarkdown is a key part of the R reproducible science scene
- RStudio is a great way to author RMarkdown documents
- Later on in this workshop, we'll see how to deal with citations so we can write academic manuscripts

### <mark>**EXERCISE 1; Create a short report**</mark> {-}

 1. Find a relevant dataset  that you recently found or are busy with at the moment*
 1. Write a short Rmd report where you LOAD and VISUALIZE (create at least 3 different graphs) the data in an Rmd report.
 1. Go over this tutorial: [RStudio Params in Rmd](https://rmarkdown.rstudio.com/developer_parameterized_reports.html%23parameter_types%2F#overview)
 1. Define one parameter in your analysis
 1. Knit two different reports of your parameterized Rmd (with two different values for one paramter defined) and sent them to the teacher
 
*If you do nog have a dataset, you can use this one:
"./data/API_AG.LND.FRST.K2_DS2_en_csv_v2_716262"

**Please send me the your report for feedback by email, or place it on you github account and send me the link.**


