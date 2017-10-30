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
    template.path.f <- file.path(template.dir, f)
    project.path.f <- file.path(path, f)
    finfo <- file.info(template.path.f)
    print(template.path.f)
    if (finfo$isdir){
      dir.create(project.path.f)
    } else {
      # Render all files as they can be templates
      if (finfo$size > 0) {
        writeLines(
          whisker::whisker.render(
            readLines(template.path.f),
            template.data),
          project.path.f)
      } else {
        # empty files just copy
        file.copy(template.path.f, project.path.f, overwrite = TRUE)
      }
    }
  }

  # Initialize Packrat
  if (use.packrat){
    packrat::init(path)
  }

}


