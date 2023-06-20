.libPaths()
.libPaths()[2]
dir(.libPaths()[2]) -> R.local.packages
R.local.packages
dir(.libPaths()[1]) -> R.local.packages
dir(.libPaths()[2]) -> R.client.packages
R.srv.packages <- read.table("~/R.srv.packages")
R.srv.packages
R.srv.packages <- R.srv.packages[,-1]
R.srv.packages
unlist(R.srv.packages)
length(unlist(R.srv.packages))
as.character(unlist(R.srv.packages))
as.character(unlist(R.srv.packages)) -> R.srv.packages
?setdiff
missing <- setdiff(R.client.packages, c(R.srv.packages,R.local.packages)
)
missing
save.images("~/R.packges.missing.RData")
save.image("~/R.packges.missing.RData")
save.history(~/R.packages.missing.R")
save.history("~/R.packages.missing.R")
?history
savehistory("~/R.packages.missing.R")
