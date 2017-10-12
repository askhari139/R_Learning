
replace <- function(m)
{
    for (i in 1:ncol(m))
    {
        for (j in 1:nrow(m))
        {
            m[j, i] <- sum(hospital$Hospital.Ownership == rownames(m)[j] &
                               hospital$State == colnames(m)[i])
        }
    }
m[2]}
    

for (i in 1:length(list_HO))
    for(j in i:1)
    {
        if 
    }