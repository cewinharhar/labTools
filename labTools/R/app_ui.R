#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import DT
#' @import bs4Dash
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic

    # Setup Loading Screen
    waiter::useWaiter(),
    waiter::waiterPreloader(
      image="www/back_small_long.jpg",
      # image="www/stableLOGO5_noBackground_small.png",
      html = waiter::spin_loaders(id=8,color="#be0a28"),
      fadeout = TRUE),
    # waiterShowOnLoad(html = spin_fading_circles()),
    waiter::autoWaiter(html = waiter::spin_loaders(id=8,color="#be0a28"), color="rgba(0,0,0,0)"),

    # Setup Dependencies ####
    # shinyjs::useShinyjs(), # For the use of shinyjs across the app
    # shinyjs::extendShinyjs(script = "www/js/mod_dep_volcano_addBrush.js", functions = c("addBrush")),
    # cicerone::use_cicerone(), # For guided app tour
    # Leave this function for adding external resources including bgs theme etc.
    golem_add_external_resources(),

    #DASHBOARD PAGE
    bs4Dash::dashboardPage(
      title = "labTools",
      fullscreen = TRUE,
      dark = TRUE,
      #--------------------------------------------------------------
      header = bs4Dash::dashboardHeader(
        title = tags$a(class="brand-link",href="#", target="_blank",
                       # tags$img(src="www/back_stable.png",class="brand-image elevation-0", style="opacity: 1;"),
                       tags$img(src="www/stableLOGO5_noBackground_small.png",class="brand-image elevation-0", style="opacity: 1;"),
                       tags$span(class="brand-text","labTools")),
        skin = "light",
        status = NULL, # needed to remove class .navbar-white from navbar (if set navbar color does not change with dark/light switch)
        border = TRUE,
        sidebarIcon = icon("bars"),
        controlbarIcon = icon("cogs"),
        fixed = TRUE,
        ## Navbar right menu ----
        rightUi = tagList(
          bs4Dash::userOutput("user"),
          dropdownMenu(
            badgeStatus = "primary",
            type = "notifications",
            notificationItem(
              inputId = "triggerAction2",
              text = "labTools Release Notes",
              icon = shiny::icon("info"),
              href = "",
              status = "primary"
            )
          )
        )
      ),
      #--------------------------------------------------------------
      ## Sidebar Left ####
      sidebar = dashboardSidebar(
        id = "left_sidebar",
        skin = "light",
        status = "primary",
        elevation = 3,
        fixed=TRUE,

        sidebarMenu(

          id = "sidebarMenu",
          #------------------
          sidebarHeader("Experimental"),
          #------------------
          menuItem(
            "Well-plate clip2table",
            tabName = "sidebarMenu_plateCopy2table",
            icon = icon("th")
          ),
          menuItem(
            "Well-plate reader",
            tabName = "sidebarMenu_plateReader",
            icon = icon("th")
          )

        )
      ),
      #--------------------------------------------------------------

      #--------------------------------------------------------------
      # DashboardFooter ----
      footer = dashboardFooter(
        left = a(
          href = "https://www.linkedin.com/in/kevin-yar-76667a192/",
          target = "_blank", "Contact: Kevin Yar"
        ),
        right = "2023"
      ),
      #--------------------------------------------------------------

      # Dashboard Body ####
      body = dashboardBody(
        ## Tab Items ####
        tabItems(
          #------------------
          tabItem(
            div(
              style = "position: absolute;
                   left: 0;
                   top: 0;
                   z-index: 10000;
                   width: 100%;
                   height: 100%;
                   background: lightblue;",
              div(
                style = "position: relative;
                     top: 30%;
                     left: 30%;",
                h1("Landing Page"),
                textInput("search", NULL),
                #Button to close landing page
                actionButton("close-landing-page", "Close")
              )
            )
          ),
          #------------------
          #------------------
          tabItem(
            tabName = "sidebarMenu_plateCopy2table",
            mod_copy2Table_ui("copy2Table_1")
          ),
          tabItem(
            tabName = "sidebarMenu_plateReader",
            box(
              width = 12,
              plate96("plate"),
              tags$b("Wells Selected:"),
              verbatimTextOutput("well_selected")
            )
          )
          # #------------------
          # tabItem(
          #   tabName = "dep_ensemble"
          #
          #
          # ),
          # #------------------
          # tabItem(
          #   tabName = "protein_details"
          #
          #
          # )
          #------------------
        )
      )
      #--------------------------------------------------------------
    ) #DASHBOARD PAGE
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny shinyjs
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    # use_favicon(path = "www/stableLOGO5_noBackground_small.ico"),
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "labTools"
    ),
    shinyjs::useShinyjs(),
    # bsplus::use_bs_tooltip(),
    # bsplus::use_bs_popover()
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
