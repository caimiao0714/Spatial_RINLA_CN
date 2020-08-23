pacman::p_load(sf, ggplot2, dplyr, extrafont)
Sys.setlocale("LC_ALL","Chinese")
font_import()
y
fonts()
loadfonts(device="win")

d = read_sf("Shapefile/Hubei/湖北省_行政边界.shp")
count(d, Layer)

Hubei_Prov = filter(d, Layer == '省')
Hubei_City = filter(d, Layer == '市')
Hubei_Cnty = filter(d, Layer == '区县')

ggplot() + 
  #geom_sf(data = Hubei_Prov, fill = NA) + 
  geom_sf(data = Hubei_City, fill = NA, size = 1) + 
  geom_sf_text(data = Hubei_City, aes(label = Name), colour = "red", family="KaiTi-GB2312") +
  #geom_sf(data = Hubei_City, fill = NA, size = 1) + 
  theme_void() + 
  theme(text = element_text(family="KaiTi-GB2312"))


