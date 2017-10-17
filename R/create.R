create_rdstemplate <- function(path, ...){
  template.dir <- system.file('template', package = 'rdstemplate')
  dir.create(path, recursive=TRUE, showWarnings=TRUE)
  file.copy(template.dir, path, recursive = TRUE)
}


