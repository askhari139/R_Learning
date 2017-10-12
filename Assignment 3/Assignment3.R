outcome_data <- read.csv("outcome-of-care-measures.csv",  colClasses = "character")

best <- function(state, outcome)
{
    if(!any(outcome_data$State == state)) stop('invalid state')
    state_data <- outcome_data[outcome_data$State == state, ]
    if (outcome == "heart attack")
        comparator = state_data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack
    else if (outcome == "heart failure")
        comparator = state_data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure
    else if (outcome == "pneumonia")
        comparator = state_data$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia
    else
        stop('invalid outcome')
    as.character(state_data$Hospital.Name[which.min(comparator)])
}

rankhospital <- function(state, outcome, rank = "best")
{
    
    if(!any(outcome_data$State == state)) stop('invalid state')
    state_data <- outcome_data[outcome_data$State == state, ]
    if (outcome == "heart attack")
        comparator = as.numeric(state_data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack)
    else if (outcome == "heart failure")
        comparator = as.numeric(state_data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure)
    else if (outcome == "pneumonia")
        comparator = as.numeric(state_data$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia)
    else
        stop('invalid outcome')
    flag = FALSE
    if (rank == "best")
    {
        rank = 1
    }
    if (rank == "worst")
    {
        rank = 1
        flag = TRUE
    }
    sort(state_data$Hospital.Name[which(comparator == sort(comparator, decreasing = flag)[rank])])
}

rankall <- function(outcome, rank = "best")
{
    if (outcome == "heart attack")
        comparator = as.numeric(outcome_data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack)
    else if (outcome == "heart failure")
        comparator = as.numeric(outcome_data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure)
    else if (outcome == "pneumonia")
        comparator = as.numeric(outcome_data$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia)
    else
        stop('invalid outcome')
    states <- levels(as.factor(outcome_data$State))
    hospitals <- c()
    flag = FALSE
    if (rank == "best")
    {
        rank = 1
    }
    if (rank == "worst")
    {
        rank = 1
        flag = TRUE
    }
    for(i in states)
    {
        state_data <- outcome_data[outcome_data$State == i, ]
        comparator_s <- comparator[outcome_data$State == i]
        hospitals = c(hospitals, sort(state_data$Hospital.Name[which(comparator_s == sort(comparator_s, decreasing = flag)[rank])])[1])
    }
    ranks <- cbind(hospitals, states)
    colnames(ranks) <- c("hospital", "state")
    return(ranks)
}