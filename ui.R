#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

suppressWarnings(library(shiny))
suppressWarnings(library(markdown))
suppressWarnings(library(shinyjs))



# Define UI for application that draws a histogram
shinyUI(navbarPage("Data Science Capstone Project",
             tabPanel("Next word prediction",
                      HTML("<strong>Author: Nirmalya Bhattacharya</strong>"),
                      br(),
                      HTML("<strong>Date: </strong><em>5/5/2018</em>"),
                      img(src = "JHUCoursera.png",align = "right"),
                      
                      # Sidebar
                      sidebarLayout(
                        sidebarPanel(
                          helpText("Next word prediction based on text input."),
                          
                          textInput("text_input", "Type a short sentence here:",value = ""),
                          br(),
                          br(),
                          br(),
                          br()
                        ),
                        

                        mainPanel(

                          inlineCSS(".alertbox { height: 40px;width:600px;background-color: #FFF6B3;color: #F58704;text-align: center;padding-top: 10px}"),
                        
                          p(class = "alertbox", id = "alertbox1", "Please wait for 5-10 seconds for the application to load ..."),
                          h2("You entered:"),
                          tags$style(type='text/css', '#text1 {background-color: rgba(247,183,108,0.40); color: #0DCDF8;}'), 
                          strong(verbatimTextOutput('text1',placeholder = TRUE)),
                          
                          h3("Possible next word:"),
                          tags$style(type='text/css', '#predicted_word {background-color: rgba(10,10,10,0.6); color: #49fb35;}'),
                          verbatimTextOutput("predicted_word",placeholder = TRUE),

                          br(),
                          
                          strong("Predicted using:"), 
                          em(textOutput('text2')),
                          br(),
                          img(src = "SwiftKey.png",align = "right"),
                          singleton(
                            tags$head(tags$script(src = "message-handler.js"))
                          )
                        )
                      )
                      
                      
             ),
             tabPanel("About",
                      mainPanel(
                        #img(src = "JHUCoursera.png"),
                        includeMarkdown("about.md")
                      )
             )
))
