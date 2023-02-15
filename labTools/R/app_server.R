#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  output$user <- bs4Dash::renderUser({
    #Sys.sleep(3) only to check spinner
    # userTable <- userInfo()$user_info$userInformation
    dashboardUser(
      # name    = paste(userTable$FirstName, userTable$LastName, sep= " "),
      name = "Demo User",
      image = "https://i2-prod.mirror.co.uk/incoming/article27881049.ece/ALTERNATES/s1200c/1_MAIN-Conor-McGregor-Hasbulla-Magomedov.jpg?strip=all&w=50",
      # title   = userTable$CustomerName,
      title = "Student",
      # subtitle   = userTable$Departement
      subtitle = "CCBIO"
    )
  })

  #-------------------------------------------------
  #####################################################################
  #INITALIZER
  #####################################################################
  #Create reactive value glibalVar
  globalVar <- reactiveValues()
  #-------------------------------------------------
  output$plate <- renderPlate96(
    "plate",
    colors = c(
      rep("#eeeeee", 12),
      rep("#27408b", 12),
      rep("#0f8b44", 12),
      rep("#9400d3", 12),
      rep("#0701ff", 12),
      rep("white", 36)
    )
  )
  #browser()
  output$well_selected <- renderPrint({
    input$plate_cells_selected
  })
  #-------------------------------------------------
  mod_copy2Table_server("copy2Table_1", globalVar = globalVar)
}
