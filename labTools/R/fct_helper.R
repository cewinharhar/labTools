#' helper
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
#'@import DT
#'@import dplyr
#'@import bs4Dash
#'@import shiny
#'@import stringr
#'@import httr
#'@import jsonlite
#'

#------------------------------------------------------------------------------------
plate96 <- function(id) {
  div(
    style = "position: relative; height: 500px",
    tags$style(HTML(
      '
        .wells {
            height: 490px;
            width: 750px;
            overflow: hidden;
            min-height: 20px;
            padding: 19px;
            margin-bottom: 20px;
            border: 1px solid #e3e3e3;
            border-radius: 4px;
            -webkit-box-shadow: inset 0 1px 1px rgb(0 0 0 / 5%);
            box-shadow: inset 0 1px 1px rgb(0 0 0 / 5%);
            position: relative;
            transform: translateX(50%);
        }

        .wells:after {
            content: "";
            height: 450px;
            width: 690px;
            border: 1px solid;
            position: absolute;
            transform: translate(15px, -100%);
            z-index: -1;
        }

        .wells .corner-top {
            position: absolute;
            margin: -20px;
            width: 43px;
            height: 34px;
            transform: rotate(45deg);
            background-color: white;
            z-index: 1;
            left: 30px;
            border-right: 1px solid;
        }

        .wells .corner-bot {
            position: absolute;
            margin: -20px;
            width: 40px;
            height: 40px;
            transform: rotate(45deg);
            background-color: white;
            z-index: 1;
            left: 35px;
            bottom: 20px;
            border-top: 1px solid;
        }

        .wells .html-widget {
            transform: translateX(20px);
        }

        .wells thead tr th {
            font-weight: 100;
        }

        .wells table:after {
            content: "";
            border: 1px solid #ccc;
            position: absolute;
            height: 410px;
            width: 635px;
            z-index: -1;
            transform: translate(33px, -99%);
        }

        .wells table.dataTable.no-footer {
            border-spacing: 3px;
            border-bottom: unset;
        }

        .wells table.dataTable thead th {
            border-bottom: unset;
        }


        .wells tbody tr td:not(:first-of-type) {
            border-radius: 50%;
            border: 1px solid black;
            height: 15px;
            width: 15px;
            padding: 15px;
            font-size: 0;
        }

        .wells table.dataTable.cell-border tbody tr td:first-of-type {
            border: unset;
            border-right: 1px solid #ccc;
            font-weight: 900;
        }
        '
    )),
    div(
      style = "position: absolute; left: 50%; transform: translateX(-100%);",
      div(
        class = "wells",
        div(class = "corner-top"),
        div(class = "corner-bot"),
        DT::dataTableOutput(id, width = "90%", height= "100%")
      )
    )
  )
}

renderPlate96 <- function(id, colors = rep("white", 96), byrow = TRUE) {
  stopifnot(is.character(colors) && length(colors) == 96)
  plate <- matrix(1:96, nrow = 8, ncol = 12, byrow = byrow, dimnames = list(LETTERS[1:8], 1:12))
  colnames(plate) <- stringr::str_pad(colnames(plate), 2, "left", "0")
  DT::renderDataTable({
    DT::datatable(
      plate,
      options = list(dom = 't', ordering = F),
      selection = list(target = 'cell'),
      class = 'cell-border compact'
    ) %>%
      formatStyle(
        1:12,
        cursor = 'pointer',
        backgroundColor = styleEqual(1:96, colors, default = NULL)
      )
  })
}
