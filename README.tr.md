# Anadolu Home — E-Ticaret Teslimat & Müşteri Elde Tutma Analizi

**İş Analisti (Business Analyst) portfolyo vaka çalışması** · SQL · SQLite · Python · Süreç haritaları · BRD · User Story

> **Not:** *Anadolu Home* **kurgusal** bir online ev eşyası perakendecisidir ve repodaki tüm veri **sentetik olarak üretilmiştir** (sabit seed, bkz. `scripts/generate_data.py`). Bu, gerçek bir şirket için yapılmış iş değil; bir problemi baştan sona nasıl ele aldığımı gösteren uygulama çalışmasıdır.

## Problem

Şirketin 2025 cirosu büyüdü ama üç sinyal endişe verici: müşterilerin yalnızca **~%27'i ikinci kez alışveriş yapıyor**, ödeme adımına geçenlerin **%57'si terk ediyor**, Black Friday cirosu sipariş sayısı %19 artmasına rağmen **Ekim'in altında kaldı**.

## Ana bulgular

1. **Geç teslimat, müşteri kaybının bir numaralı sebebi:** İlk siparişi 3+ gün geç gelenlerin tekrar satın alma oranı %7,1; zamanında gelenlerde %39,1.
2. **Eşik etkisi var:** 1–2 gün gecikme puanı neredeyse etkilemiyor (4,07 vs 4,09); 3+ gün gecikmede puan 2,71'e düşüyor.
3. **Gecikme coğrafi:** Van, Diyarbakır, Trabzon'da teslimatların %83–95'i geç.
4. **Mobilya** hem en yüksek iade oranına (%13,9) hem en düşük marja (%37,5) sahip.
5. **Black Friday indirimi geliri eritti:** Sipariş +%19, ama sepet ortalaması ₺2.663 → ₺2.053.
6. **Kanal seçimi kaldıraç değil:** Tüm kanallarda tekrar alım oranı ~%25–28.

## İçerik

`docs/` altında iş gerekçesi ve gereksinimler (BRD), paydaş analizi ve RACI, AS-IS/TO-BE süreç haritaları, user story'ler, SQL sonuçları ve öncelikli öneri/yol haritası bulunur. Detaylar İngilizce yazılmıştır → [README.md](README.md).

## Çalıştırma

```bash
python scripts/generate_data.py
python scripts/run_analysis.py
```

**Oğuzhan Kul** · Yönetim Bilişim Sistemleri · İzmir · [GitHub](https://github.com/Oguzhan-35)
