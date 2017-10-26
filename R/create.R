create_rdstemplate <- function(path, use.packrat, ...){
  # Create directory for new project
  dir.create(path, recursive=TRUE, showWarnings=TRUE)

  # Collect all necessary data for file render
  template.data <- as.list(match.call())
  template.data$r.version = paste(R.version$major, R.version$minor, sep='.')


  # Copy files from ./inst/template to new project
  template.dir <- system.file('template', package = 'rdstemplate')
  template.files <- list.files(template.dir, all.files = TRUE, recursive = TRUE, include.dirs = TRUE)
  for (f in template.files){
    finfo <- file.info(f)
    if (finfo$is.dir){
      dir.create(file.path(path, f))
    } else {
      # Render all files as they can be templates
      writeLines(
        whisker::whisker.render(
          readLines(file.path(template.dir, f)),
          template.data),
        file.path(path, f))
    }
  }

  # Initialize Packrat
  if (use.packrat){
    packrat::init(path)
  }

}


