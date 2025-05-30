


install.packages(c("httr", "jsonlite", "dplyr", "tibble", "tidytext", "stringr", "ggplot2","textdata","wordcloud","RColorBrewer","tidyverse","readxl"))
library(httr)             # API verisi cekmek icin kullanilir
library(jsonlite)         # JSON formatindaki veriyi duzenlemek icin
library(dplyr)            # Veri duzenleme ve filtreleme icin
library(tibble)           # Tablo biciminde veri olusturmak icin
library(tidytext)         # Metin madenciligi ve duygu analizi icin
library(readxl)           # Excel dosyasi okumak icin
library(stringr)          # Metin duzenleme ve arama islemleri icin
library(ggplot2)          # Grafik olusturmak icin
library(textdata)         # Duygu sozluklerini (AFINN, NRC vb.) indirmek icin
library(wordcloud)        # Kelime bulutu gorseli olusturmak icin
library(RColorBrewer)     # Grafikler icin renk paletleri saglar
library(tidyverse)        # Veri isleme ve gorsellestirme icin genis paket koleksiyonu








api_key <- "FB5E61AD17191CA09E5BD2F2335EDFA8"

steam_yorum_cek <- function(app_id, oyun_adi, max_yorum = 1000) {
  library(httr)
  library(jsonlite)
  library(dplyr)
  library(tibble)
  
  options(scipen = 999)  # Bilimsel gosterimi kapat
  
  yorumlar <- list()
  cursor <- "*"
  toplam_cekilen <- 0
  
  repeat {
    url <- paste0("https://store.steampowered.com/appreviews/", app_id,
                  "?json=1&filter=recent&num_per_page=100&cursor=", URLencode(cursor, reserved = TRUE))
    
    response <- GET(url)
    if (http_error(response)) break
    content_raw <- content(response, as = "text", encoding = "UTF-8")
    json_data <- fromJSON(content_raw)
    
    if (is.null(json_data$reviews) || length(json_data$reviews) == 0) break
    
    yeni_yorumlar <- json_data$reviews %>%
      transmute(
        yorum = review,
        oyun_adi = oyun_adi,
        oyun_saati = round(author$playtime_forever / 60, 2),  # Saati 2 basamakli  yaz
        begenildi_mi = voted_up,
        tarih = as.POSIXct(timestamp_created, origin = "1970-01-01", tz = "UTC")
      )
    
    yorumlar[[length(yorumlar) + 1]] <- yeni_yorumlar
    toplam_cekilen <- toplam_cekilen + nrow(yeni_yorumlar)
    
    if (!json_data$success | toplam_cekilen >= max_yorum | is.null(json_data$cursor)) break
    
    cursor <- json_data$cursor
    Sys.sleep(1)
  }
  
  bind_rows(yorumlar)
}



yorum_lastofus<-steam_yorum_cek(app_id = 1888930, oyun_adi = "Lastofus")
yorum_rdr2 <- steam_yorum_cek(app_id = 1174180, oyun_adi = "Red Dead Redemption 2")
yorum_eldenring <- steam_yorum_cek(app_id = 1245620, oyun_adi = "Elden Ring")
yorum_cyberpunk <- steam_yorum_cek(app_id = 1091500, oyun_adi = "Cyberpunk 2077")
yorum_Baldursgate <- steam_yorum_cek(app_id = 1086940, oyun_adi = "Baldur's Gate 3")
yorum_Hogwars <- steam_yorum_cek(app_id = 990080, oyun_adi = "Hogwarts Legacy")
yorum_stardew <- steam_yorum_cek(app_id = 413150, oyun_adi = "Stardew Valley")
yorum_witcher3 <- steam_yorum_cek(app_id = 292030, oyun_adi = "Witcher 3:Wild Hunt ")
yorum_detroit <- steam_yorum_cek(app_id = 1222140, oyun_adi = "Detroit Become Human")
yorum_spiderman <- steam_yorum_cek(app_id = 1817070, oyun_adi = "Spiderman Remastered")
yorum_hades <- steam_yorum_cek(app_id = 1145360, oyun_adi = "Hades")
yorum_resident4 <- steam_yorum_cek(app_id =  2050650, oyun_adi = "Resident Evil 4 ")
yorum_gta5 <- steam_yorum_cek(app_id =  271590, oyun_adi = "Grand Theft Auto V  ")
yorum_sims4 <- steam_yorum_cek(app_id =  1222670, oyun_adi = "The Sims 4  ")


# Tum olumsuz elestirilen oyunlarin yorumlarini cekiyoruz
yorum_csgo <- steam_yorum_cek(app_id = 730, oyun_adi = "CSGO")
yorum_dota2 <- steam_yorum_cek(app_id = 570, oyun_adi = "Dota 2")
yorum_pubg <- steam_yorum_cek(app_id =  578080, oyun_adi = "PUBG")
yorum_efootball <- steam_yorum_cek(app_id = 1665460, oyun_adi = "eFootball 2022")
yorum_battlefield <- steam_yorum_cek(app_id = 1517290, oyun_adi = "Battlefield 2042")
yorum_fallout <- steam_yorum_cek(app_id = 1151340, oyun_adi = "Fallout 76")
yorum_daybefore <- steam_yorum_cek(app_id = 1372880, oyun_adi = "The Day Before")
yorum_nba2k20 <- steam_yorum_cek(app_id = 1089350, oyun_adi = "NBA 2K20")
yorum_gotham <- steam_yorum_cek(app_id = 1496790, oyun_adi = "Gotham Knights")
yorum_callofduty<- steam_yorum_cek(app_id = 1938090, oyun_adi = "Call of Duty: MWII (2022)")



# Hepsini birlestiriyoruz
hepsi_df <- bind_rows(
  yorum_lastofus,
  yorum_rdr2,
  yorum_eldenring,
  yorum_cyberpunk,
  yorum_Baldursgate,
  yorum_Hogwars,
  yorum_stardew,
  yorum_witcher3,
  yorum_detroit,
  yorum_spiderman,
  yorum_hades,
  yorum_resident4,
  yorum_gta5,
  yorum_sims4,
  yorum_csgo,
  yorum_dota2,
  yorum_pubg,
  yorum_efootball,
  yorum_battlefield,
  yorum_fallout,
  yorum_daybefore,
  yorum_nba2k20,
  yorum_gotham,
  yorum_callofduty
)

#excel dosyasina kaydettik
library(writexl)
write_xlsx(hepsi_df, "yorumlar1.xlsx")

#okut
library(readxl)

file_path <- file.choose()

# Excel dosyasini oku
yorumlar <- read_excel(file_path)

head(yorumlar)

#R da veri temizleme

library(tidytext)
library(dplyr)
library(stringr)

# Temizlik + kelime ayristirma



temiz_yorumlar <- yorumlar %>%
  # Kucuk harfe cevirmek icin
  mutate(yorum = tolower(yorum)) %>%  
  # Sadece harfleri alalim(sayilar ve noktalama isaretlerini sil)
  mutate(yorum = str_replace_all(yorum, "[^[:alpha:] ]", " ")) %>% 
  # Kelimelere ayir
  unnest_tokens(word, yorum) %>%   
  #Gereksiz ingilizce kelimeleri sil
  anti_join(stop_words, by = "word")     




#gereksiz tekrar eden kelimeleri cikar

library(dplyr)

# Temizlenecek kelimeler
gereksiz_kelimeler <- c("fucking","bf","ass","dont","isn","ea","im","fuck","shit",
                        "fallout","aminake","bolas", "ve", "don", "didn", "doesn", 
                        "ll", "elden", "stardew", "spider", "ps", "dlc", "pc","the", 
                        "and", "it","games","played","playing","hours","lot","feels",
                        "gameplay","characters","harry","batman","potter","sims","hades",
                        "witcher","battlefield","left","dota","yeah","lots","times","arkham",
                        "fighting","enjoyed ","runs","de")

# Filtreleme
yorumlar_df_temiz <- temiz_yorumlar  %>%
  filter(!word %in% gereksiz_kelimeler)




#en cok tekrar eden kelimeler
library(ggplot2)
library(dplyr)

kelime_frekans <- yorumlar_df_temiz %>%
  count(word, sort = TRUE)  #kelimenin kac kez gectigini sayar ve siralar.

head(kelime_frekans, 10)  

kelime_frekans %>%
  slice_max(n, n = 10) %>%
  ggplot(aes(x = reorder(word, n), y = n)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(title = "En S??k Ge??en 10 Kelime", x = "Kelime", y = "Frekans") +
  theme_minimal()



yorumlar_df_temiz %>%
  count(word, sort = TRUE) %>%
  top_n(20, n) %>%
  ggplot(aes(x = reorder(word, n), y = n)) +
  geom_col(fill = "darkorange") +
  geom_text(aes(label = n), hjust = -0.2, size = 4) +  # Say??lar?? ekler
  coord_flip() +
  labs(
    title = "En cok gecen 20 kelime",
    x = "Kelime",
    y = "Frekans"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold"),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 13)
  )

#notr eklendi 
# AFINN sozlugu: -5 ile +5 arasi skor verir
duygu_sozlugu <- get_sentiments("afinn")

# Kendi kelimelerinle eslestir
yorumlar_duygu <- yorumlar_df_temiz %>%
  inner_join(duygu_sozlugu, by = c("word" = "word")) %>%
  mutate(duygu = case_when(
    value > 0 ~ "Pozitif",
    value < 0 ~ "Negatif",
    is.na(value) ~ "Notr"
  ))

head(yorumlar_df_duygu, 10) 
library(dplyr)
library(tidytext)

# 1. Kelime sutunun adini "word" gibi ayarla (gerekirse)
yorumlar_df_temiz <- yorumlar_df_temiz %>%
  rename(word = kelime)  # Eger kelime sutunun adi farkliysa



# AFINN sozlugu: -5 ile +5 arasi skor verir
duygu_sozlugu <- get_sentiments("afinn")

# notr,poz,neg
yorumlar_df_duygu <- yorumlar_df_temiz %>%
  left_join(get_sentiments("afinn"), by = "word") %>%
  mutate(value = ifelse(is.na(value), 0, value),
         duygu = case_when(
           value > 0 ~ "Pozitif",
           value < 0 ~ "Negatif",
           TRUE ~ "Notr"
         ))




library(ggplot2)

yorumlar_df_duygu %>%
  count(duygu) %>%
  ggplot(aes(x = duygu, y = n, fill = duygu)) +
  geom_col() +
  labs(title = "Kelime Bazli Duygu Dagilimi",
       x = "Duygu Turu",
       y = "Kelime Sayisi") +
  theme_minimal()


#pasta
duygu_sayim <- yorumlar_df_duygu %>%
  count(duygu)

# Pie chart ??izimi
ggplot(duygu_sayim, aes(x = "", y = n, fill = duygu)) +
  geom_col(width = 1) +
  coord_polar(theta = "y") +
  labs(title = "Kelime Bazl?? Duygu Da????l??m?? (Pie Grafik)") +
  theme_void() +  # Arka plani sadelestir
  scale_fill_brewer(palette = "Set1")





#neg,poz,notr karsilastirma
yorumlar_df_duygu %>%
  count(Oyun = oyun_adi, duygu) %>%
  ggplot(aes(x = Oyun, y = n, fill = duygu)) +
  geom_col(position = "dodge") +
  labs(title = "Oyunlara Gore Duygu Dagilimi",
       x = "Oyun",
       y = "Kelime Sayisi") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
#poz,neg grafik

yorumlar_duygu %>%
  count(Oyun = oyun_adi, duygu) %>%
  ggplot(aes(x = Oyun, y = n, fill = duygu)) +
  geom_col(position = "dodge") +
  labs(title = "Oyunlara Gore Duygu Dagilimi",
       x = "Oyun",
       y = "Kelime Sayisi") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

yorumlar_df_duygu %>%
  group_by(tarih = as.Date(timestamp)) %>%
  summarise(ortalama_duygu = mean(value)) %>%
  ggplot(aes(x = oyun_saati, y = ortalama_duygu)) +
  geom_line(color = "blue") +
  labs(title = "Zamana G??re Ortalama Duygu Skoru",
       x = "Tarih",
       y = "Duygu Skoru") +
  theme_minimal()


#pozitif negatif analizi

library(tidytext)
library(dplyr)
library(ggplot2)

# Bing sozlugunu al
bing_duygu <- get_sentiments("bing")

yorum_duygu_df <- yorumlar_df_temiz %>%
  inner_join(bing_duygu, by = "word")  # sadece eslesen kelimeler alinir.

yorum_duygu_df %>%
  count(sentiment, word, sort = TRUE) %>%
  group_by(sentiment) %>%
  top_n(10, n) %>%
  ungroup() %>%
  ggplot(aes(x = reorder(word, n), y = n, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ sentiment, scales = "free_y") +
  coord_flip() +
  labs(title = "En cok gecen pozitif ve negatif kelimeler",
       x = "Kelime", y = "Frekans") +
  scale_fill_manual(values = c("positive" = "green3", "negative" = "firebrick2")) +
  theme_minimal()

#oyunlar bazinda pozitif ve negatif yorum oranlari

yorum_duygu_df <- yorumlar_df_temiz %>%
  inner_join(get_sentiments("bing"), by = "word")

oyun_duygu_oranlari <- yorum_duygu_df %>%
  group_by(oyun_adi, sentiment) %>%
  summarise(adet = n(), .groups = "drop") %>%
  tidyr::pivot_wider(names_from = sentiment, values_from = adet, values_fill = 0) %>%
  mutate(toplam = positive + negative,
         pozitif_oran = round(positive / toplam, 3),
         negatif_oran = round(negative / toplam, 3)) %>%
  arrange(desc(pozitif_oran))


print(oyun_duygu_oranlari)


library(ggplot2)

oyun_duygu_oranlari %>%
  ggplot(aes(x = reorder(oyun_adi, pozitif_oran), y = pozitif_oran)) +
  geom_col(fill = "pink") +
  coord_flip() +
  labs(title = "Oyunlara Gore Pozitif Yorum Orani",
       x = "Oyun", y = "Pozitif Yorum Orani") +
  theme_minimal()

oyun_duygu_oranlari %>%
  ggplot(aes(x = reorder(oyun_adi, negatif_oran), y = negatif_oran)) +
  geom_col(fill = "red") +
  coord_flip() +
  labs(title = "Oyunlara Gore Negatif Yorum Orani",
       x = "Oyun", y = "Negatif Yorum Orani") +
  theme_minimal()

library(stringr)
# Oyun adi sutununu temizleme (bosluklar ve ozel karakterleri kaldirma)
yorumlar_df_temiz <- yorumlar_df_temiz %>%
  mutate(oyun_adi = str_trim(oyun_adi),  # Baslangic ve bitis bosluklarini temizle
         oyun_adi = str_replace_all(oyun_adi, "[^[:alnum:] ]", ""))  # ozel karakterleri kaldir

# Duygu analizi k??sm?? 
yorum_duygu_df <- yorumlar_df_temiz %>%
  inner_join(bing_duygu, by = "word")

# Oyun bazinda pozitif ve negatif yorumlarin toplamlarini aliyoruz
oyun_duygu_oranlari <- yorum_duygu_df %>%
  group_by(oyun_adi, sentiment) %>%
  summarise(adet = n(), .groups = "drop") %>%
  tidyr::pivot_wider(names_from = sentiment, values_from = adet, values_fill = 0) %>%
  mutate(toplam = positive + negative,
         pozitif_oran = round(positive / toplam, 3),
         negatif_oran = round(negative / toplam, 3)) %>%
  arrange(desc(pozitif_oran))

# Oyunlari pozitif oranlarina gore siralama
print(oyun_duygu_oranlari)

# Pozitif yorum oran??na gore gorsellestirme
oyun_duygu_oranlari %>%
  ggplot(aes(x = reorder(oyun_adi, pozitif_oran), y = pozitif_oran)) +
  geom_col(fill = "pink") +
  coord_flip() +
  labs(title = "Oyunlara Gore Pozitif Yorum Orani",
       x = "Oyun", y = "Pozitif Yorum Orani") +
  theme_minimal()

# En cok olumlu/olumsuz yorum alan oyunlari siralama
en_populer_oyunlar <- oyun_duygu_oranlari %>%
  arrange(desc(pozitif_oran)) %>%
  top_n(10, pozitif_oran)  # En cok pozitif yorum alan 10 oyun

# En cok olumsuz yorum alan oyunlari siralama
en_populer_negatif_oyunlar <- oyun_duygu_oranlari %>%
  arrange(desc(negatif_oran)) %>%
  top_n(10, negatif_oran)  # En cok negatif yorum alan 10 oyun

# Sonuclari gorsellestirme
ggplot(en_populer_oyunlar, aes(x = reorder(oyun_adi, pozitif_oran), y = pozitif_oran)) +
  geom_col(fill = "darkorange") +
  coord_flip() +
  labs(title = "En Cok Olumlu Yorum Alan 10 Oyun", x = "Oyun", y = "Olumlu Yorum Sayisi") +
  theme_minimal()

ggplot(en_populer_negatif_oyunlar, aes(x = reorder(oyun_adi, negatif_oran), y = negatif_oran)) +
  geom_col(fill = "firebrick2") +
  coord_flip() +
  labs(title = "En Cok Olumsuz Yorum Alan 10 Oyun", x = "Oyun", y = "Olumsuz Yorum Sayisi") +
  theme_minimal()

#oyun_adi              negative positive toplam pozitif_oran negatif_oran
#<chr>                    <int>    <int>  <int>        <dbl>        <dbl>
# 1 Stardew Valley             515     1171   1686        0.695        0.305
#2 Spiderman Remastered       594     1199   1793        0.669        0.331
#3 Hades                     1042     1692   2734        0.619        0.381
#4 Lastofus                  1031     1637   2668        0.614        0.386
#5 Detroit Become Human      1026     1543   2569        0.601        0.399
#6 Cyberpunk 2077             952     1360   2312        0.588        0.412


install.packages("wordcloud")
install.packages("RColorBrewer")
library(wordcloud)
library(RColorBrewer)

# En cok gecen kelimeleri say
kelime_frekans <- yorumlar_df_temiz %>%
  count(word, sort = TRUE)

# Kelime bulutu olusturalim
set.seed(123)  # Rastgeleligi sabitle
wordcloud(words = kelime_frekans$word,
          freq = kelime_frekans$n,
          min.freq = 5,
          max.words = 200,
          random.order = FALSE,
          rot.per = 0.35,
          colors = brewer.pal(8, "Dark2"))






library(dplyr)
library(ggplot2)
library(tidytext)
library(textdata)

# AFINN sozlugu
afinn <- get_sentiments("afinn")


yorumlar_duygu <- yorumlar_df_temiz %>%
  left_join(afinn, by = "word") %>%
  mutate(duygu_skoru = ifelse(is.na(value), 0, value)) %>%
  group_by(doc_id) %>%
  summarise(toplam_skor = sum(duygu_skoru)) %>%
  mutate(polarite = case_when(
    toplam_skor > 0 ~ "Pozitif",
    toplam_skor < 0 ~ "Negatif",
    TRUE ~ "N??tr"
  ))

# Grafik
ggplot(yorumlar_duygu, aes(x = polarite, fill = polarite)) +
  geom_bar() +
  labs(title = "Yorumlarin Polarite Dagilimi",
       x = "Duygu Turu",
       y = "Yorum Sayisi") +
  theme_minimal()
