file_names = 'paste(formatC(id, width = 3, flag = "0"), ".csv", sep = "")'


pollutantmean = function(directory, pollutant, id = 1:322)
{
    setwd(directory)
    values = c()
    data_files = paste(formatC(id, width = 3, flag = "0"), ".csv", sep = "")#eval(parse(file_names))
    for (i in data_files)
    {
        values = c(values, read.csv(i)[,pollutant])
    }
    mean(values, na.rm = TRUE)
}

complete = function(directory, id=1:322)
{
    #setwd(directory)
    completes = c()
    data_files = paste(formatC(id, width = 3, flag = "0"), ".csv", sep = "")
    for (i in data_files)
    {
        completes = c(completes, sum(complete.cases(read.csv(i))))
    }
    df = data.frame(id,completes)
    colnames(df) = c("id","nobs")
    df
}

corr = function(directory, threshold = 0)
{
    #setwd(directory)
    id = 1:322
    corre = c()
    data_files = paste(formatC(id, width = 3, flag = "0"), ".csv", sep = "")
    for (i in data_files)
    {
        data = read.csv(i)
        if(sum(complete.cases(data)) > threshold) {corre = c(corre, cor(data[complete.cases(data),"sulfate"],data[complete.cases(data),"nitrate"]))}
    }
    corre
    
}

