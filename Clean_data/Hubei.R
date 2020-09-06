pacman::p_load(sf, ggplot2, readr, data.table, dplyr, showtext, viridis)
Sys.setlocale("LC_ALL","Chinese")
crs_cn = '+init=epsg:4508'

# add fonts
font_add("NotoSerif", "NotoSerifCJKsc-Regular.otf")
font_add("NotoSansMono", "NotoSansMonoCJKsc-Regular.otf")
font_add("NotoSansCJK", "NotoSansCJKsc-Regular.otf")
showtext_auto()

Hubei = read_sf("Shapefile/Hubei/Hubei.shp")

Hubei_City = filter(Hubei, Layer == '市') %>% 
  mutate(Name = gsub('市|林区|土家族苗族自治州', '', Name))
Hubei_Cnty = filter(Hubei, Layer == '区县')

ggplot() + 
  geom_sf(data = Hubei_Cnty, fill = NA, size = 0.3, color = 'gray70') + 
  geom_sf(data = Hubei_City, fill = NA, size = 1, color = 'black') + 
  geom_sf_text(data = Hubei_City, aes(label = Name), 
               colour = "blue", family = "NotoSerifBold", size = 7) +
  theme_void() + 
  coord_sf(crs = st_crs(crs_cn))

ggsave('Figures/1Intro/Hubei_City.png', width = 10*0.3, height = 6.18*0.3, dpi = 600)
ggsave('Figures/1Intro/Hubei_City.pdf', width = 10, height = 6.18)



#--------------------------
d = read_csv('https://raw.githubusercontent.com/BlankerL/DXY-COVID-19-Data/master/csv/DXYArea.csv')

d1 = d %>% 
  filter(countryName == '中国' & !is.na(cityName) & city_zipCode != 0) %>% 
  dplyr::select(provinceName, province_confirmedCount, province_deadCount, 
                updateTime, cityName, city_zipCode, 
                city_confirmedCount, city_deadCount) %>% 
  mutate(updateTime = lubridate::ymd_hms(updateTime),
         cityName = gsub('市|林区', '', cityName),
         cityName = gsub('恩施州', '恩施', cityName)) %>% 
  mutate(Date = lubridate::date(updateTime))

d2 = d1 %>% 
  filter(provinceName == '湖北省') %>% 
  as.data.table() %>% 
  .[order(cityName, updateTime)]

hubeiCOVID19 = d2 %>% 
  group_by(cityName) %>% 
  filter(row_number() == n()) %>% 
  dplyr::select(cityName, city_confirmedCount, city_deadCount, city_zipCode)


Hubei_City = filter(Hubei, Layer == '市') %>% 
  mutate(Name = gsub('市|林区|土家族苗族自治州', '', Name)) %>% 
  left_join(hubeiCOVID19, by = c('Name' = 'cityName')) %>% 
  mutate(confirmedCount_cat = case_when(
    city_confirmedCount < 500 ~ '0-500',
    city_confirmedCount >= 500 & city_confirmedCount < 1000 ~ '501-1000',
    city_confirmedCount >= 1000 & city_confirmedCount < 1500 ~ '1001-1500',
    city_confirmedCount >= 1500 & city_confirmedCount < 4000 ~ '1501-4000',
    city_confirmedCount >= 4000 ~ '>4000'
  )) %>% 
  mutate(confirmedCount_cat = factor(confirmedCount_cat, levels = 
    c('0-500', '501-1000', '1001-1500', '1501-4000', '>4000')))

ggplot() + 
  geom_sf(data = Hubei_Cnty, fill = NA, size = 0.3, color = 'gray70') + 
  geom_sf(data = Hubei_City, aes(fill = confirmedCount_cat), 
          size = 1, color = 'black') + 
  scale_fill_viridis_d(option="magma", direction = -1) +
  theme_void() + 
  coord_sf(crs = st_crs(crs_cn))
