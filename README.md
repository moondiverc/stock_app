# Stock App

Stock App adalah aplikasi mobile yang menampilkan informasi mengenai tren saham, berita relevan terkait pasar, informasi mengenai perusahaan saham, dan profile pengguna. Aplikasi ini mengimplementasikan pemanggilan API dari AlphaVantage API dan Yahoo Finance untuk mendapatkan data yang diperlukan. Aplikasi ini dibangun menggunakan Flutter dengan state management menggunakan flutter_bloc. Aplikasi ini juga mengimplementasikan clean architecture dengan memisahkan kode ke dalam layer presentation, domain, dan data. Selain itu, aplikasi ini juga mengimplementasikan caching data menggunakan Hive untuk menyimpan data secara lokal sehingga dapat diakses tanpa koneksi internet.

## Fitur & Teknologi

### Fitur

- Stock Overview = Halaman berisi kumpulan stock yang terbagi menjadi 3 kategori, yaitu Gainers, Losers, dan Active. Ketika tap card stock yang dipilih akan navigasi ke halaman company overwiew yang berisi informasi mengenai perusahaan dimana stock tersebut.
- News Sentiment = Halaman berisi kumpulan berita terbaru yang relevan dengan pasar. Ketika tap card berita yang dipilih akan navigasi ke halaman detail berita yang berisi informasi mengenai thumbnail berita, sentiment label, authors, judul berita, summary berita, dan url launcher menuju web sumber berita
- Profile = Halaman berisi informasi pribadi mengenai nama, umur, jurusan, occupation, status, lokasi, deskripsi, dan gambar. Terdapat tambahan fungsi untuk mengedit informasi tersebut. Semua data disimpan di local data source menggunakan hive dan path_provider.
- Company Overview = Halaman berisi informasi mengenai perusahaan stock dimana pada halaman terdapat informasi diantaranya adalah price, change percentage, grafik history prices, market cap, P/E ratio, div yield, sector, overview perusahaan, dan url launcher menuju web perusahaan.

### Packages

- flutter_bloc
- fpdart
- get_it
- internet_connection_checker_plus
- http
- url_launcher
- hive
- path_provider
- yahoo_finance_data_reader

## Lesson Learned

## Referensi

- https://pub.dev/
- https://github.com/ivofernandes/yahoo_finance_demo
- https://www.youtube.com/watch?v=ELFORM9fmss
- https://www.youtube.com/watch?v=nNXE1Sd99t0&list=PLCaS22Sjc8YTzcwGENMFDVc4XDRA2p3Ho&index=4
- https://www.alphavantage.co/documentation/
