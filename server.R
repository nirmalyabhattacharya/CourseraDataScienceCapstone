#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


suppressWarnings(library(shiny))
suppressWarnings(library(tidyr))
suppressWarnings(library(quanteda))
suppressWarnings(library(feather))


# Load Quadgram,Trigram & Bigram Data frame files

bigram <- read_feather("datafiles/bigram.feather")
trigram <- read_feather("datafiles/trigram.feather")
quadgram <- read_feather("datafiles/quadgram.feather")

prediction_output <<- ""

predict_next_word <- function (input_string){
  input_string_cleaned <- tokens(input_string, remove_punct = TRUE, remove_numbers = TRUE, remove_url = TRUE, concatenator = " ")$text1

  if (length(input_string_cleaned)>= 3) {
    input_string_cleaned <- tail(input_string_cleaned,3)
    if (identical(character(0),head(quadgram[quadgram$unigram == input_string_cleaned[1] & quadgram$bigram == input_string_cleaned[2] & quadgram$trigram == input_string_cleaned[3], 4],1))){
      predict_next_word(paste(input_string_cleaned[2],input_string_cleaned[3],sep=" "))
    }
    else {prediction_output <<- "quadgrams."; head(quadgram[quadgram$unigram == input_string_cleaned[1] & quadgram$bigram == input_string_cleaned[2] & quadgram$trigram == input_string_cleaned[3], 4],1)$quadgram}
  }
  else if (length(input_string_cleaned) == 2){
    input_string_cleaned <- tail(input_string_cleaned,2)
    if (identical(character(0),head(trigram[trigram$unigram == input_string_cleaned[1] & trigram$bigram == input_string_cleaned[2], 3],1))) {
      predict_next_word(input_string_cleaned[2])
    }
    else {prediction_output<<- "trigrams."; head(trigram[trigram$unigram == input_string_cleaned[1] & trigram$bigram == input_string_cleaned[2], 3],1)$trigram}
  }
  else if (length(input_string_cleaned) == 1){
    input_string_cleaned <- tail(input_string_cleaned,1)
    if (identical(character(0),head(bigram[bigram$unigram == input_string_cleaned[1], 2],1))) {prediction_output<<-"No match found. Most common word 'the' is returned."; head("the",1)}
    else {prediction_output <<- "bigrams."; head(bigram[bigram$unigram == input_string_cleaned[1],2],1)$bigram}
  }
  else if (length(input_string_cleaned) < 1){
    prediction_output <<- ""
  }
}
  
  


# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {

  observe({
    session$sendCustomMessage(type = 'dataloaded',message = "OK")
     });
  

  output$predicted_word <- renderText({
    result <- predict_next_word(input$text_input)
    output$text2 <- renderText({prediction_output})
    result
  });
  
  output$text1 <- renderText({
    input$text_input});
})
