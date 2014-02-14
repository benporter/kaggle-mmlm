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

results_denorm <- sqldf("select tr.*,
                                s.years, 
                                s.dayzero
                         from tourney_results tr
                              left join
                              seasons s 
                              on s.season = tr.season")

head(results_denorm)

wins <- sqldf("select wteam,years,count(*) as wins
               from results_denorm
               group by wteam, years
               order by wteam, years")

losses <- sqldf("select lteam,years,count(*) as losses
               from results_denorm
               group by lteam, years
               order by lteam, years")

win_loss <- sqldf("select w.*,
                          l.losses
                   from wins w
                        left join losses l
                        on w.wteam = l.lteam and
                           w.years = l.years")




