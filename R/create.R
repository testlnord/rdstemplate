create_rdstemplate <- function(path, use_packrat, install_default_packages, project_name, ...){
  # Create directory for new project
  dir.create(path, recursive=TRUE, showWarnings=TRUE)
  print(path)

  # Collect all necessary data for file render
  project.metadata <- as.list(match.call())
  project.metadata$r_version = paste(R.version$major, R.version$minor, sep='.')


  # initialise list of files to ignore during copying
  if (system.file('ignore.txt', package = 'rdstemplate') != ""){
    ignore.file.list <- readLines(system.file('ignore.txt', package = 'rdstemplate'))
  } else {
    ignore.file.list <- c()
  }

  # Copy files from ./inst/template to new project
  template.dir <- system.file('template', package = 'rdstemplate')
  template.files <- list.files(template.dir, all.files = TRUE, recursive = TRUE, include.dirs = TRUE)
  for (f in template.files){
    # ignore files
    if (any(sapply(ignore.file.list, function(ignore.mask){grepl(ignore.mask, f)}))){
      next
    }
    template_file_path <- file.path(template.dir, f)
    project_file_path <- file.path(path, f)
    finfo <- file.info(template_file_path)

    if (nrow(finfo) > 0 & !is.na(finfo$isdir)){
      if (finfo$isdir){
        dir.create(project_file_path)
      } else {
        # Render all files as they can be templates
        if (finfo$size > 5){
          writeLines(
            whisker::whisker.render(
              readLines(template_file_path),
              project.metadata),
            project_file_path)
        } else {
          # just copying too small files
          file.copy(template_file_path, project_file_path)
        }
      }
    }
  }

  save(project.metadata, file=file.path(path, 'project.meta.rda'))


  # Initialize Packrat
  if (use.packrat){
    packrat::init(path, restart = FALSE)
  }

  # install default packages
  if (use.packrat & install.default.packages){
    def.packages.file <- system.file('default_packages.txt', package = 'rdstemplate')
    for (package.name in readLines(def.packages.file)){
      print(file.path(path, package.name))
      if (file.exists(package.name) & file.info(package.name)$isdir){
        devtools::install(package.name)
      } else {
        install.packages(package.name)
      }
    }
  }


}


