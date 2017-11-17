packets <- c("shiny", "ggiraph", "ggplot2", "ggthemes")

to_install <- packets[!(packets %in% installed.packages()[, "Package"])]

if(length(to_install)) install.packages(to_install)

sapply(packets, library, character.only = TRUE)