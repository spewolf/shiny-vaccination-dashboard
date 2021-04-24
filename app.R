#
# United States Vaccine Rollout Dashboard
# Spencer Wolf
#
# This application allows users to interact with data from the our wold in data
# github page found here: 
#
# https://github.com/owid/covid-19-data/blob/master/public/data/vaccinations/us_state_vaccinations.csv
#

library(shiny)
library(shinyWidgets)
library(dplyr)
library(ggplot2)
library(plotly)

# Get Data
state_names = c("Alaska", "Alabama", "Arkansas", "American Samoa", "Arizona", "California", "Colorado", "Connecticut", "District of Columbia", "Delaware", "Florida", "Georgia", "Guam", "Hawaii", "Iowa", "Idaho", "Illinois", "Indiana", "Kansas", "Kentucky", "Louisiana", "Massachusetts", "Maryland", "Maine", "Michigan", "Minnesota", "Missouri", "Mississippi", "Montana", "North Carolina", "North Dakota", "Nebraska", "New Hampshire", "New Jersey", "New Mexico", "Nevada", "New York State", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Puerto Rico", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Virginia", "Virgin Islands", "Vermont", "Washington", "Wisconsin", "West Virginia", "Wyoming")

data = read.csv(url("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/us_state_vaccinations.csv")) %>% 
    mutate(date = as.Date(date, format = "%Y-%m-%d")) %>%
    filter(location %in% state_names)
states = (data %>% group_by(location) %>% summarise())$location

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel(h1("United States Vaccine Rollout Dashboard")),
    h4("Spencer Wolf"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            tags$head(
                tags$style(HTML('#clear{background-color:red; color:white; margin:0 0 0 .4rem;}'))
            ),
            checkboxGroupInput("selected_states",
                               "Select states",
                               choices = state_names,
                               selected= c("Ohio", "Indiana", "New York State", "Alabama", "Alaska")),
            actionGroupButtons(
                inputIds=c("show_all", "clear"),
                labels=list("Show All", "Clear All"),
                direction = "horizontal",
            ),
            width = 2),

        # Show a plot of the generated distribution
        mainPanel(
           plotlyOutput("vaccinePlot"),
           titlePanel(h2("State Statistics")),
           dataTableOutput("selected_state_stats_dt")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    # Actions for selecting states
    observeEvent(input$clear, {
        updateCheckboxGroupInput(session, "selected_states", choices=state_names, selected=NULL)
    })
    
    observeEvent(input$show_all, {
        updateCheckboxGroupInput(session, "selected_states", choices=state_names, selected=state_names)
    })
    
    # Header plot with full vaccinations per capita
    output$vaccinePlot <- renderPlotly({
        g = data %>% filter(location %in% input$selected_states) %>%
                drop_na() %>%
                ggplot(aes(date, people_fully_vaccinated_per_hundred, colour = location,
                           text = paste0(format(date, "%d %B %Y"), "\n", location, ": ",people_fully_vaccinated_per_hundred))) +  
                geom_point(size = 1, alpha = 0.8) +
                theme(legend.title = element_blank(), legend.position = "", plot.title = element_text(size=10)) +
                xlab("Date") + 
                ylab("People Fully Vaccinated per 100 people") +
                ggtitle("Full Vaccinations per Capita")
        ggplotly(g, tooltip = c("text")) %>% layout(legend = list(font = list(size=11)))
    })
    
    # Individual state stats datatable
    output$selected_state_stats_dt = renderDataTable({
        data %>% filter(location %in% input$selected_states) %>%
            arrange(location, date) %>% 
            group_by(location) %>% 
            summarise(across(everything(), last)) %>%
            select(location, people_fully_vaccinated_per_hundred, people_vaccinated_per_hundred, total_vaccinations) %>%
            rename("State"=location, 
                   "Fully Vaccinated Per 100"=people_fully_vaccinated_per_hundred, 
                   "First Dose Per 100"=people_vaccinated_per_hundred,
                   "Total Vaccinations"=total_vaccinations)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
