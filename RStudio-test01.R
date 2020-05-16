print("This file was created within RStudio")

print("And now it is live on Github")

pacman::p_load(pacman, tidyverse, rio)

# Six common verbs in dplyr -----------------------------------------------

# select() - picks columns based on their names
# filter() - picls rows based on their values
# group_by() - groups the data based on one/ more variables
# summarize() - reduced multiple values down to a single summary
# mutate() - adds new columns using existing columns
# arrange() - changes the ordering of the rows

(tmp <- iris %>% sample_n(size = 3))


# select() ----------------------------------------------------------------

# basic, use variables' name with comma
(tmp %>% select(Sepal.Length, Species))
# pattern matching with starts_with, ends_with, contains
(tmp %>% select(starts_with("Sepal"), Species))
(tmp %>% select(ends_with("Length"), contains("Sp")))
# select and rename at the same time
(tmp %>% select(SL=Sepal.Length, Type=Species))
# use rename() if want all column but rename some
(tmp %>% rename(SW=Sepal.Width, SL=Sepal.Length, Type=Species))
# use "-" minus symbol to drop column(s)
(tmp %>% select(-Species))
(tmp %>% select(-starts_with("Sepal"), -Species))
# do not mix positive and negative selection in one select()


# filter() ----------------------------------------------------------------

# can specify multiple conditions and only rows passing all conditions are included
my_iris <- iris %>% 
  filter(Sepal.Length > 4.5, Sepal.Width < 3)
# pip to dim(), count(), glimpse(), view() to have a quick idea of the output
my_iris %>% dim()
my_iris %>% count()
my_iris %>% glimpse()
my_iris %>% view()


# mutate() ----------------------------------------------------------------

# mutate() to generate new column(s)
iris %>% 
  mutate(Sepal.Area = Sepal.Length * Sepal.Width,
         Petal.Area = Petal.Length * Petal.Width) %>% 
  filter(Sepal.Area>10) %>% 
  view()


# summarize() or summarise() ----------------------------------------------

# to calculate the mean of the Sepal.Length variable
iris %>% 
  summarise(SL.Mean = mean(Sepal.Length))  # output is stored as named dataframe

# can generate multiple summaries
iris %>% 
  summarise(n = n(),
            SL.mean = mean(Sepal.Length),
            SL.sd = sd(Sepal.Length))

# use summarize_all() to apply same function to all columns
iris %>% 
  select(-Species) %>% 
  summarise_all(.funs = "mean")


# group_by() --------------------------------------------------------------

# group_by splits the data according to one/ more variables
iris %>% 
  group_by(Species) %>% 
  summarise_all(.funs = "mean") %>% 
  knitr::kable()  # knitr::kable() generate a prettier table


# package: skimr ----------------------------------------------------------

pacman::p_load(skimr)
skimr::skim(iris)  # a quick method to summarize dataframe


# package: GGally ---------------------------------------------------------

pacman::p_load(GGally)
GGally::ggpairs(iris, aes(color=Species, alpha=0.6)) +
  theme_bw()  # a quick method to generate summary plots


# cut ---------------------------------------------------------------------

# use cut() to separate the data in a variable into groups
cut.point <- c(-Inf, 0.5, 1.5, Inf)
cp.labels <- c("low", "median", "high")

iris %>% 
  mutate(PW.group = cut(Petal.Width, cut.point, labels = cp.labels)) %>% 
  sample_n(10) %>% 
  view()


# package: tabyl ----------------------------------------------------------

pacman::p_load(janitor)

# one-way tabyl
cw <- readxl::read_excel("./chick_weight.xlsx", sheet = 2)
cw %>% tabyl(feed)  
# though there is missing values, a "valid_percent" will be output

# two-way tabyl: two-way tabulation between feed and weight category
brk <- c(-Inf, 200, 300, Inf)
brk.labels <- c("low", "medium", "high")

tb <- cw %>% 
  mutate(grp = cut(weight, brk, labels = brk.labels)) %>% 
  tabyl(feed, grp) %>% 
  arrange(low, medium, high)
print(tb)

# pair tabyl() with adorn_* to get more info
tb %>% 
  adorn_totals("col") %>% 
  adorn_percentages("row") %>% 
  adorn_pct_formatting(digits = 0) %>% 
  adorn_ns(position = "front")
