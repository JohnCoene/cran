# CRAN

Code for the [CRAN Dependency Graph](http://shiny.john-coene.com/cran) visualisation.

![](https://grapher.network/img/grapher-demo.png)

If you want to reproduce this locally, run the short script in the `script` directory.

```bash
Rscript ./script/script.R
```

Then launch the application from R.

```r
source("app.R")
shinyApp(ui, server)
```

It is intended as demo for [grapher](https://grapher.network).

[Pull Requests](https://github.com/JohnCoene/cran/pulls), [raising issues](https://github.com/JohnCoene/cran/issues), and other feedback is welcome. Please see the [blog post](https://grapher.network/blog/2019/11/02/cran) describing how it is built if you want to know more.
