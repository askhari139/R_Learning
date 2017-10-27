library(ggplot2)

### concealing plot elements in named variables and adding them to the plot

## functions like geom_point
x <- "geom_point()"
y <- geom_point()
z <- parse(text = x)
ggplot(data.frame(x1 = 1:10, y1 = 1:10), aes(x1, y1)) + y #works
#ggplot(data.frame(x1 = 1:10, y1 = 1:10), aes(x1, y1)) + x #doesn't work
#ggplot(data.frame(x1 = 1:10, y1 = 1:10), aes(x1, y1)) + z #doesnt work
ggplot(data.frame(x1 = 1:10, y1 = 1:10), aes(x1, y1)) + eval(z) #works




##aesthetics
p <- "x1"
q <- "y1"
ggplot(data.frame(x1 = 1:10, y1 = 1:10), aes_string(p, q)) + eval(z)
# aes_string is the function to use for variable saved aesthetics

##must ggplot always come first?
eval(z) + ggplot(data.frame(x1 = 1:10, y1 = 1:10), aes_string(p, q)) #returns NULL
 
geom_