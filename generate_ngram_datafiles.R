# Data Science Capstone Project
# This is the R script for generating R Data files for N-grams. These files will be used later by the Shiny App to quickly load the N-grams data. 
#________________________________________________________________________________________________________________________________________________

# IMPORTANT: 

# On Mac (High Sierra or above) run the command:
# Download the gfortran from the official site and install
# Open a terminal and run the following commands:
#   mkdir ~/.R
#   cat << EOF >> ~/.R/Makevars
# 
# These steps are required for using the "quanteda" library.

#________________________________________________________________________________________________________________________________________________
  
# Change the current working directory to the directory this script is  
thisdir<-getSrcDirectory(function(x) {x}) #Anonymous function to get the source directory. The anonymous function is dummy.

setwd(file.path(thisdir))



library(R.utils)
library(tidyr)
library(quanteda)

# Read the data from the respective files

blogs_text <- readLines("final/en_US/en_US.blogs.txt",skipNul = TRUE, encoding="UTF-8")
news_text <- readLines("final/en_US/en_US.news.txt",skipNul = TRUE, encoding="UTF-8")
twitter_text <- readLines("final/en_US/en_US.twitter.txt",skipNul = TRUE, encoding="UTF-8")


#Sample the data

sample_text <- function(full_text, part) {
  sample_values <- sample(1:length(full_text), length(full_text)*part)
  sampletext <- full_text[sample_values]
  sampletext
}

set.seed(0)
part <- 0.05

blogs_sample <- sample_text(blogs_text, part)
news_sample <- sample_text(news_text, part)
twitter_sample <- sample_text(twitter_text, part)

combined_sample <- c(blogs_sample, news_sample, twitter_sample)

# Free up some memory:

rm(blogs_text,news_text,twitter_text,blogs_sample,news_sample,twitter_sample)

create_ngram <- function (raw_data, n) {
  column_names<-c("unigram","bigram","trigram","quadgram")
  ngram_tokens <- tokens(raw_data, remove_punct = TRUE, remove_numbers = TRUE, remove_url = TRUE, concatenator = " ", ngrams = n)
  ngram_dfm<-dfm(ngram_tokens,tolower = TRUE)
  dfm_remove(ngram_dfm, stopwords("english"))
  ngram_df_temp <- data.frame(Content = featnames(ngram_dfm), Frequency = colSums(ngram_dfm), row.names = NULL, stringsAsFactors = FALSE)
  ngram_df_temp_sorted  <- ngram_df_temp[order(-ngram_df_temp$Frequency),]
  ngram_df_temp_colnames  <- separate(ngram_df_temp_sorted, Content, into=c(column_names[0:n]), sep = " ", remove = TRUE)
  row.names(ngram_df_temp_colnames) <- 1:nrow(ngram_df_temp_colnames)
  ngram <- ngram_df_temp_colnames
  ngram
}


save_ngram_data <- function(ngram_dataframe) {
  name_dataframe <- deparse(substitute(ngram_dataframe))
  filename <- paste(name_dataframe, "rds", sep=".")
  saveRDS(ngram_dataframe, filename, compress = TRUE)
  
}


# Calculate N-Grams

bigram <- create_ngram(combined_sample, 2)
save_ngram_data(bigram)
trigram <- create_ngram(combined_sample, 3)
save_ngram_data(trigram)
quadgram <- create_ngram(combined_sample, 4)
save_ngram_data(quadgram)

# Free up some more memory

rm(bigram,trigram,quadgram,combined_sample)




