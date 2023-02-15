#' copy2Table UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_copy2Table_ui <- function(id){
  ns <- NS(id)
  tagList(

    box(
      title = "paste excel", width = 12,
      textAreaInput(
        inputId = ns("data_pasted"),
        label = "Paste data here:",
        height = "300px",
        width = "100%",
        resize = "none"
      )
    ),
    ####

    box(
      title = "Table", width = 12,
      DT::dataTableOutput(ns("table1"))
    )

  )
}

#' copy2Table Server Functions
#'
#' @noRd
mod_copy2Table_server <- function(id, globalVar){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # tableOut <- reactive({
    #     browser()
    #     df <- data.table::fread(paste(input$data_pasted, collapse = "\n"))
    # })

    observe({

      # browser()
      req(input$data_pasted)

      if (input$data_pasted == "" || is.null(input$data_pasted)){
        return(NULL)
      }

      dataPasted <- input$data_pasted

      tryCatch(
        expr = {
          tableOut <- data.table::fread(paste(dataPasted, collapse = "\n"))
        },
        error = function(err){
          print(err)
          return()
        }
      )


      tableOutput <- tableOut[,c(4, 9)] %>%
        filter(V4 != "Value" | V9 != "Value")

      finTab <- tableOutput[seq(1, nrow(tableOutput), by = 2), ] %>%
        as.data.frame()
      # browser()
      rownames(finTab) <- LETTERS[1:nrow(finTab)]
      colnames(finTab) <- seq(1:ncol(finTab)) %>% as.character()
      # browser()
      globalVar$tableOut <- finTab
    })

    observe({
      # browser()
      req(globalVar$tableOut)
      output$table1 <- DT::renderDataTable({
        # browser()
        DT::datatable(
          #-----------------  DATA INPUT-------------
          data = globalVar$tableOut,
          #-------------------------------------
          extensions = "Buttons",
          style = "bootstrap4",
          options = list(
            # selection="multiple",
            # escape=FALSE,
            # filter = 'top',
            # scrollX = TRUE,
            # dom = '<"top">Bflrt<"bottom">ip',
            dom = "Brftipl",
            buttons = c(
              #one button for copy to clipboard
              "copy",
              #and two for either csv or xlsx download
              list(list(extend = "csv",   filename = "copyFromTecanReader")),
              list(list(extend = "excel", filename = "copyFromTecanReader"))
            )
          )
        )
      }
      )
    })







    # observe({
    #   browser()
    #   req(globalVar$tableOut)
    #
    #   output$table1 <- DT::renderDT(server = TRUE,{
    #       DT::datatable(
    #         #-----------------  DATA INPUT-------------
    #         data = globalVar$tableOut,
    #         #-------------------------------------
    #         extensions = "Buttons",
    #         style = "bootstrap4",
    #         options = list(
    #           buttons = c(
    #             #one button for copy to clipboard
    #             "copy",
    #             #and two for either csv or xlsx download
    #             list(list(extend = "csv",   filename = "copyFromTecanReader")),
    #             list(list(extend = "excel", filename = "copyFromTecanReader"))
    #           )
    #         )
    #       )
    #
    #     }
    #   )
    #
    # })

  })
}

## To be copied in the UI
# mod_copy2Table_ui("copy2Table_1")

## To be copied in the server
# mod_copy2Table_server("copy2Table_1")
