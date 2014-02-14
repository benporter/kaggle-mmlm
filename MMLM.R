# Purpose:     Kaggle Competition:  March Machine Learning Mania
# Programmer:  Ben Porter
# Date:        2/13/2014
# kaggle link: https://www.kaggle.com/c/march-machine-learning-mania/data
# github link: https://github.com/benporter/R-import-sql-export/tree/master

############################
# Load Libraries
############################

library(sqldf)


getwd()
setwd("C:/Users/Ben/Documents/R/March Machine Learning Mania/input data")

regular_season_results <- read.csv(file="regular_season_results.csv",header=TRUE)
seasons                <- read.csv(file="seasons.csv",header=TRUE)
teams                  <- read.csv(file="teams.csv",header=TRUE)
tourney_results        <- read.csv(file="tourney_results.csv",header=TRUE)
tourney_seeds          <- read.csv(file="tourney_seeds.csv",header=TRUE)
tourney_slots          <- read.csv(file="tourney_slots.csv",header=TRUE)
sample_submission      <- read.csv(file="sample_submission.csv",header=TRUE)

head(regular_season_results)
seasons
head(teams)
head(tourney_results)
head(tourney_seeds)
head(tourney_slots)
head(sample_submission)


# join tourney_results, with seasons and tourney_seeds
results_denorm <- sqldf("select tr.*,
                                s.years, 
                                s.dayzero,
                                tsw.seed as wseed,
                                tsl.seed as lseed
                         from tourney_results tr
                              left join
                              seasons s 
                              on s.season = tr.season
                              
                              left join
                              tourney_seeds tsw
                              on tr.season = tsw.season and
                                 tr.wteam  = tsw.team
                              
                              left join
                              tourney_seeds tsl
                              on tr.season = tsl.season and
                                 tr.lteam  = tsl.team")

head(results_denorm)

# attached the df for direct column refernces
attach(results_denorm)

# extract the 2 digit seed and store as a number
results_denorm$wseed_num <- as.numeric(substr(wseed,2,3))
results_denorm$lseed_num <- as.numeric(substr(lseed,2,3))

# assume the larger seed wis
results_denorm$naive_pred <- ifelse(wseed_num>lseed_num,wteam,lteam)

# test the naive prediction against actuals
results_denorm$naive_correct <- ifelse(naive_pred==wteam,1,0)

# reverse the attach
detach(results_denorm)

# results of the naive prediction
summary(results_denorm$naive_correct)


# count up the number of wins, per team, per year
wins <- sqldf("select wteam,years,count(*) as wins
               from results_denorm
               group by wteam, years
               order by wins desc, wteam, years")




