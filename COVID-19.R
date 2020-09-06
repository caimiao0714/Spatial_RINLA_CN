#remotes::install_github("GuangchuangYu/nCov2019")

library(nCov2019)
pacman::p_load(dplyr, readr)
x <- get_nCov2019()

class(x)
str(x)


x
x[]
View(x[])
View(x[1,])

summary(x)#全国各省数据

open(x)

str(x)



# National data
pacman::p_load(dplyr, readr)
nCov2019::get_nCov2019() %>%
  summary() %>%
  readr::write_csv("data/nCov2019_temp/national_updated.csv")

# Province-level data
dprov = nCov2019::get_nCov2019() %>%
  .[] 

readr::write_csv(dprov, paste0("data/nCov2019_temp/province_", Sys.Date(), ".csv"))


# City-level data
library(nCov2019)
library(dplyr)
library(readr)

x <- nCov2019::get_nCov2019()
Prov_name = x[]$name
city_data = list()
for (i in 1:length(Prov_name)) {
  city_data[[i]] = x[i,] %>%
    mutate(province = Prov_name[i]) %>%
    mutate_if(is.factor, as.character)
}

x <- get_nCov2019()
dcity = bind_rows(city_data) %>%
  select(province, city = name, everything())

write_csv(paste0("data/nCov2019_temp/city_", Sys.Date(), ".csv"))


bind_rows(city_data) %>%
  select(province, city = name, everything())


library(nCov2019)
x <- get_nCov2019()
x[1,]

pacman::p_load(dplyr, data.table)
x1 = load_nCov2019() %>% 
  summary() %>% 
  as.data.table

d1 = readr::read_csv('https://raw.githubusercontent.com/canghailan/Wuhan-2019-nCoV/master/Wuhan-2019-nCoV.csv') %>% 
  as.data.table()



county_meta = readr::read_csv('https://raw.githubusercontent.com/canghailan/Wuhan-2019-nCoV/master/ChinaAreaCode.csv')
readr::write_csv(county_meta, 'Data/county_meta.csv')




