# 🎮 Steam Yorumlarıyla Duygu Analizi (R)

## 📌 Proje Açıklaması
Bu projede Steam platformundaki popüler oyunlara ait kullanıcı yorumları analiz edilmiştir.  
Amaç, metin madenciliği teknikleriyle kullanıcı yorumlarının duygu yönünü (pozitif/negatif) ve kelime frekanslarını incelemektir.

## 📁 Veri Kümesi
Veriler, Steam'den toplanan yorumlardan oluşmaktadır.  
Kullanıcı adları ve kimlik bilgileri çıkarılmıştır.  
Veri setine buradan ulaşabilirsiniz:  
[Steam Yorumları Excel Dosyası (Temizlenmiş)](https://docs.google.com/spreadsheets/d/1va6G1xXhSAnriBd-QzRyLwc1ECkMQ4sz/edit?usp=drive_link)

## 🛠️ Kullanılan Teknolojiler ve Kütüphaneler
- R dili
- `tidytext`, `dplyr`, `ggplot2`, `wordcloud`, `readxl`
- Duygu sözlükleri: **AFINN** ve **Bing**

## 🔍 Yapılan Analizler
1. **Veri Temizleme:** Küçük harfe çevirme, noktalama ve durak kelimelerin (stopwords) temizlenmesi
2. **Frekans Analizi:** En sık geçen kelimelerin sayılması ve görselleştirilmesi
3. **Duygu Analizi:** AFINN ve Bing sözlükleriyle yorumların olumlu/olumsuz yönlerinin belirlenmesi
4. **Kelime Bulutu:** Sık kullanılan kelimelerin görsel temsili
5. **Polarite Analizi:** Yorumların genel duygu skorlarının hesaplanması ve görselleştirilmesi

## 📊 Örnek Görselleştirmeler
>

- En sık geçen kelimeler grafiği
- > ![image](https://github.com/user-attachments/assets/1626589f-8c57-4bcf-a64f-88c90ce8095f)

- Olumlu/olumsuz/nötr yorumların dağılımı
- ![image](https://github.com/user-attachments/assets/d802964e-6283-45ac-ad60-d9c6090f5e90)

- Kelime bulutu (wordcloud)
- ![image](https://github.com/user-attachments/assets/36581d0c-2186-4646-8b80-571835a86c89)
 
- Polarite skorlarına göre yorum sınıflandırması  
![image](https://github.com/user-attachments/assets/ca6d6d81-50fc-4d70-8ae5-9e95c093e66b)

-En cok Oynanan Oyunlar
![image](https://github.com/user-attachments/assets/c82b0c4d-d828-4300-b05f-9ce225ae5009)

## ✅ Sonuç
Analiz sonucunda, kullanıcı yorumlarının büyük kısmı olumlu eğilim göstermektedir.  
Bu çalışma, oyun geliştiricileri için kullanıcı geri bildirimlerini anlamada yol gösterici olabilir.

## 👩‍💻 Geliştiren
[Eda](https://github.com/eda22)  
İstatistik ve Bilgisayar Bilimleri Öğrencisi  
Bilecik Şeyh Edebali Üniversitesi
