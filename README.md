# Stock App 📊

Stock App adalah aplikasi mobile yang menampilkan informasi mengenai tren saham, berita relevan terkait pasar, informasi mengenai perusahaan saham, dan profile pengguna. Aplikasi ini mengimplementasikan pemanggilan API dari AlphaVantage API dan Yahoo Finance untuk mendapatkan data yang diperlukan. Aplikasi ini dibangun menggunakan Flutter dengan state management menggunakan flutter_bloc. Aplikasi ini juga mengimplementasikan clean architecture dengan memisahkan kode ke dalam layer presentation, domain, dan data. Selain itu, aplikasi ini juga mengimplementasikan caching data menggunakan Hive untuk menyimpan data secara lokal sehingga dapat diakses tanpa koneksi internet.

## Fitur & Teknologi 💻

### Fitur

- Stock Overview = Halaman berisi kumpulan stock yang terbagi menjadi 3 kategori, yaitu Gainers, Losers, dan Active. Ketika tap card stock yang dipilih akan navigasi ke halaman company overwiew yang berisi informasi mengenai perusahaan dimana stock tersebut.
- News Sentiment = Halaman berisi kumpulan berita terbaru yang relevan dengan pasar. Ketika tap card berita yang dipilih akan navigasi ke halaman detail berita yang berisi informasi mengenai thumbnail berita, sentiment label, authors, judul berita, summary berita, dan url launcher menuju web sumber berita
- Profile = Halaman berisi informasi pribadi mengenai nama, umur, jurusan, occupation, status, lokasi, deskripsi, dan gambar. Terdapat tambahan fungsi untuk mengedit informasi tersebut. Semua data disimpan di local data source menggunakan hive dan path_provider.
- Company Overview = Halaman berisi informasi mengenai perusahaan stock dimana pada halaman terdapat informasi diantaranya adalah price, change percentage, grafik history prices, market cap, P/E ratio, div yield, sector, overview perusahaan, dan url launcher menuju web perusahaan.

### Packages

- flutter_bloc : state management
- fpdart : error handling with functional programming approach
- get_it : dependency injection
- internet_connection_checker_plus : checking user internet connection
- http : API call
- url_launcher : launching url to external web
- hive : local data source
- path_provider : getting path to store local data source
- yahoo_finance_data_reader : get stock data and history price from Yahoo Finance
- google_fonts : custom font

## Lesson Learned 📌

Selama proses pembuatan Stock App, saya mempelajari alur pengembangan aplikasi yang sistematis dan berkualitas tinggi melalui penerapan best practice yang saya temukan dari beberapa sumber referensi. Saya berusaha agar secara konsisten mengimplementasikan Clean Architecture dan SOLID principles untuk menjaga scalability kode, serta menggunakan state management flutter_bloc. Tahapan pengembangan yang saya lakukan dimulai dari penyusunan struktur folder yang modular dan penentuan theme dan core, kemudian saya melakukan integrasi API untuk menjamin ketersediaan data, dan mulai mengembangkan detail UI pada setiap fitur. Setiap harinya, saya melakukan analisis terhadap kode yang telah dibuat untuk mencari celah optimasi agar struktur aplikasi tetap clean. Alur pengembangan setiap fitur saya lakukan secara konsisten adalah saya memulai dari membangun domain layer (entity & repository interface), menyusun data layer (model & data source implementation), kemudian menghubungkannya ke presentation layer melalui use case dan dependency injection menggunakan get_it. Setelah semua fitur sudah terimplementasi dengan baik, aku mengimplementasikan local data source menggunakan hive, path_provider, dan internet_connection_checker_plus untuk mengecek koneksi internet user dan mengambil data dari local apabila tidak ada koneksi internet.

Banyak teknologi baru yang saya eksplorasi dalam proyek ini untuk mendukung fungsionalitas dan pengalaman user pada setiap halamannya. Saya menggunakan package http untuk pemanggilan API, hive dan path_provider untuk caching data secara efisien ke dalam local data source. Hal ini memungkinkan aplikasi tetap responsif dan dapat diakses meskipun dalam kondisi koneksi internet yang terbatas dan koneksi internet user dapat dicek melalui internet_connection_checker_plus. Untuk mengelola dependency secara modular, saya mengimplementasikan service locator melalui get_it. Selain itu, saya juga mengintegrasikan berbagai library pendukung yang esensial, seperti yahoo_finance_data_reader untuk mendapatkan data stock dan history price dari Yahoo Finance, url_launcher untuk memberikan akses langsung ke situs web eksternal perusahaan, serta penggunaan google_fonts untuk menambahkan custom font pada aplikasi.

## Referensi 🗂️

- https://pub.dev/
- https://github.com/ivofernandes/yahoo_finance_demo
- https://www.youtube.com/watch?v=ELFORM9fmss
- https://www.youtube.com/playlist?list=PLCaS22Sjc8YTzcwGENMFDVc4XDRA2p3Ho
- https://www.youtube.com/playlist?list=PLXbYsh3rUPSzuLcZsIkpDmftSQbFmUq9x
- https://www.alphavantage.co/documentation/
