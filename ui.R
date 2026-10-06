# Title: ui.R
# Purpose: defines user-interface of calculator


ui <- fluidPage(
  
  useShinyFeedback(), # for error messages if putting in BMI/age outwith range
  
  titlePanel("Calculator for estimated chance of natural pregnancy leading to live birth, for couples diagnosed with infertility"),
  sidebarLayout(
    sidebarPanel(
      h4(
        "Enter patient characteristics at the point of diagnosis of infertility."
      ),
      hr(),
      h4("Couple Details"),
      numericInput(
        "FAge",
        "Female age:",
        value = 30,
        min = 18,
        max = 49,
        step = 1
      ),
      numericInput(
        "duryrsWin",
        "Duration of infertility (years):",
        value = 1,
        min = 0,
        max = 10,
        step = 0.5
      ),
      numericInput(
        "BMIWin",
        "Female BMI:",
        value = 25,
        min = 16,
        max = 50,
        step = 0.1
      ),
      # Radio buttons for binary inputs.
      radioButtons(
        inputId = "FSecInf",
        label = "History of previous pregnancy in female partner?",
        choices = c("Yes" = 1, "No" = 0),
        selected = 0
      ),
      
      radioButtons(
        inputId = "EverSmoke",
        label = "Has the female partner ever been a smoker?",
        choices = c("Yes" = 1, "No" = 0),
        selected = 0
      ),
      
      radioButtons(
        inputId = "EverAlc",
        label = "Any history of alcohol use in female partner?",
        choices = c("Yes" = 1, "No" = 0),
        selected = 0
      ),
      
      hr(),
      
      h4("Causes of infertility"),
      
      checkboxInput("spermdx", "Diagnosis of male factor infertility?", value = FALSE),
      checkboxInput("endometdx", "Diagnosis of endometriosis?", value = FALSE),
      checkboxInput("ovulatory", "Diagnosis of anovulatory infertility?", value = FALSE),
      checkboxInput("Unexplained", "Diagnosis of unexplained infertility?", value = FALSE),
      checkboxInput("Tubal", "Diagnosis of tubal infertility i.e. blocked, missing or damaged fallopian tube(s)?", value = FALSE),
      checkboxInput("other", "Other infertility diagnosis i.e. cervical, uterine or sexual problem?", value = FALSE)
    ),
    mainPanel(
      actionButton(inputId = "calculate",
                   label = "Calculate chance of live birth",
                   class = "btn-primary btn-lg"),
      hr(), # horizontal rule for separation
      
      h3(
        "Predicted probability of natural pregnancy within first year from diagnosis of infertility, leading to a live birth:"
      ),
      
      wellPanel(
        span(textOutput("risk_output"), style = "font-size:20px; font-weight: bold; color: #004a99")
        
      ),
      
      htmlOutput("interpretation_text"), #interpretation of result based on calculated risk
      
      hr(),
      
      tags$em( #make text italic
        p(
          tags$strong("DISCLAIMER:"), #makes the first word bold
          "This tool uses the information you have entered above to estimate the individual chance of a ",
          tags$strong("live birth resulting from a natural pregnancy"),
          ". ",
          "Specifically, it estimates the chance of spontaneous pregnancy occurring within the first year from a diagnosis of infertility (and before starting any treatment), with that pregnancy going on to lead to a live birth. ",
          br(), br(),
          "These estimates are based on the patient data we used when making this model, and represents the outcomes of couples with similar characteristics to those you have entered into the calculator. 
          7086 couples were included in the original study, who registered at a single tertiary fertility centre between 1998-2015.",
          br(),
          tags$strong("As such, the estimate may not represent your experience. "),
          "This is particularly important in characteristics where we had fewer patients to base our estimates on, such as the",
          tags$strong("higher age groups, or people with very low or very high BMI."),
          br(),
          "It is important to note that in women with very low BMI the accuracy of predictions may be low, as research shows there is a lower chance of pregnancy in this group due to ovulatory problems.",
          br(), br(),
          "We would recommend to interpret these results with caution and alongside discussions with your medical team about your individual fertility journey."
        )
      ),
      
      hr(),
      
      div(
        style = "font-size: 0.9em; color: #555",
        p(
        "The source code used to build this calculator is freely available online at",
        a("our GitHub repository.",
          href = "https://github.com/nataliejcameron/LB_calc",
          target = "_blank")
      ))
  )
))
