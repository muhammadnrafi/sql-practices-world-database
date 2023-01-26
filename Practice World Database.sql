USE world;

-- Ada berapa bahasa di dunia?
SELECT COUNT(DISTINCT(Language)) AS jumlah_bahasa FROM countrylanguage;

-- Ada berapa negara yang memiliki bahasa Inggris sebagai bahasa Official
SELECT COUNT(Language) AS jumlah_bahasa FROM countrylanguage WHERE Language='English' AND IsOfficial='T';

-- Tampilkan nama, populasi dan GNP dari negara yang berasal dari region Southeast Asia
SELECT Name, Population, GNP FROM country WHERE Region='Southeast Asia';

-- Berapa rata-rata life expectancy negara di asia?
SELECT AVG(LifeExpectancy) AS rata_harapan_hidup FROM country WHERE Continent='Asia';

-- Berapa rata-rata life expectancy negara di asia?
SELECT DISTINCT(Region) FROM country WHERE Continent='Europe';

-- Ada berapa kota besar di negara Belanda (country code= nld)
SELECT COUNT(Name) AS jumlah_kota FROM city WHERE CountryCode='nld';

-- Berapa jumlah populasi kota-kota di negara India (ind)
SELECT SUM(Population) AS jumlah_populasi FROM city WHERE CountryCode='ind';

-- Tampilkan nama dan populasi 10 kota pertama di Indonesia
SELECT Name, Population FROM city WHERE CountryCode='idn' Limit 10;

-- Menampilkan negara dengan populasi diatas rata rata populasi dunia
SELECT AVG(population) AS rata_populasi FROM country;
SELECT name, population FROM country WHERE population>(SELECT AVG(population) FROM country) ORDER BY population;

-- tampilkan region di dunia yang memiliki lifeex diatas rata rata dunia
SELECT AVG(lifeexpectancy) FROM country;
SELECT region, AVG(lifeexpectancy) AS rata_harapan_hidup FROM country GROUP BY region HAVING rata_harapan_hidup>(SELECT AVG(lifeexpectancy) FROM country);

-- Tampilkan 10 negara dengan populasi terbanyak yang memiliki nama berakhiran huruf e.
SELECT name, population FROM country WHERE name LIKE '%e' ORDER BY population DESC LIMIT 10;

-- Ada berapa negara yang merdeka di antara tahun 1900-1945?
SELECT COUNT(*) FROM country WHERE indepyear BETWEEN 1900 AND 1945;

-- tampilkan 5 negara yang memiliki jumlah distrik paling banyak.
SELECT * FROM city;
SELECT countrycode, COUNT(DISTINCT(district)) AS jumlah_distrik FROM city GROUP BY countrycode ORDER BY jumlah_distrik DESC LIMIT 5;

-- Tampilkan 10 negara yang memiliki kepala negara dengan nama paling panjang.
SELECT * FROM country;
SELECT name, headofstate, length(headofstate) AS panjang_nama FROM country ORDER BY panjang_nama DESC LIMIT 10;

-- Ada berapa negara dengan kepala negara yang memiliki huruf e pada posisi kedua namanya.
SELECT COUNT(*) AS jumlah FROM country WHERE headofstate LIKE '_e%';

-- Tampilkan total luas area berdasarkan benuanya, diurutkan dari yang paling kecil.
SELECT * FROM country;
SELECT continent, SUM(surfacearea) AS luas_area FROM country GROUP BY continent ORDER BY luas_area;

-- Tampilkan 2 negara dengan bahasa resmi paling banyak.
USE world;
SELECT * FROM countrylanguage;
SELECT countrycode, COUNT(Language) AS jumlah_bahasa FROM countrylanguage WHERE IsOfficial='T' GROUP BY countrycode ORDER BY jumlah_bahasa DESC LIMIT 2;

-- Tampilkan nama region di Asia dan Eropa yang memiliki total GNP lebih dari 1,000,000!
SELECT * FROM country;
SELECT region, SUM(GNP) AS total_gnp FROM country WHERE continent='Asia' OR continent = 'Europe' GROUP BY region HAVING total_gnp>1000000;

-- Ada berapa negara di data world?
SELECT count(*) AS jumlah_negara FROM country;

-- Tampilkan rata-rata harapan hidup berdasarkan benua
SELECT continent, AVG(lifeexpectancy) AS average_life_expectancy
    FROM country
    GROUP BY continent;
    
-- Tampilkan Jumlah region di masing-masing benua
SELECT continent, COUNT(DISTINCT(region)) AS jumlah_region
    FROM country
    GROUP BY continent;
    
-- Tampilkan rata-rata GNP di Afrika berdasarkan regionnya
SELECT region, AVG(GNP) AS average_gnp
    FROM country
    WHERE continent='Africa'
    GROUP BY region;
    
-- Tampilkan negara di Eropa yang memiliki nama dimulai dari huruf I
SELECT name AS Negara FROM country WHERE name LIKE "i%" AND continent="europe";

-- Tampilkan 10 negara dengan GNP di atas rata-rata GNP negara-negara di benua Oceania, diurutkan dari yang terbesar
SELECT name as Negara, GNP 
    FROM country WHERE GNP > (SELECT AVG(GNP) FROM country WHERE continent='oceania') 
    ORDER BY GNP DESC
    LIMIT 10;
    
-- Tampikan GNP negara belanda, ibukota beserta populasi dari ibukotanya
SELECT country.name AS Country, country.GNP, city.name AS Capital, city.population
    FROM country, city
    WHERE country.capital = city.id AND country.name='Netherlands';
    
-- 10 negara mana yang memiliki persentase pemakai bahasa spanyol paling tinggi
SELECT country.name AS negara, countrylanguage.percentage AS persentase
    FROM country, countrylanguage 
    WHERE country.code = countrylanguage.countrycode AND language='spanish'
    ORDER BY persentase DESC
    LIMIT 10;
    
-- Tampikan GNP negara Indonesia, ibukota, populasi dari ibukotanya dan bahasa resmi yang dipakai
SELECT country.name AS negara, country.gnp, city.name AS ibukota, city.population, countrylanguage.language AS bahasa
    FROM country
    INNER JOIN city
    ON country.capital = city.ID 
    INNER JOIN countrylanguage
    ON country.code=countrylanguage.countrycode
    WHERE countrylanguage.countrycode='idn' AND countrylanguage.isofficial='T';
    
-- Tampilkan 10 nama negara (Name) dan jumlah bahasa (language) baik yang official maupun tidak di tiap negara, dari tabel Country dan CountryLanguage! Tampilkan hanya negara yang jumlah bahasanya di atas rata-rata jumlah bahasa semua negara! Urutkan dari negara yang jumlah bahasanya paling banyak!
with negara_bahasa AS (
    select country.name as negara, count(language) as jumlah_bahasa
    from country join countrylanguage on country.code=countrylanguage.countrycode
    group by negara
),
rata_bahasa as(
    select avg(jumlah_bahasa) as rata_jumlah from negara_bahasa
)
select *
from negara_bahasa
where jumlah_bahasa > (select rata_jumlah from rata_bahasa)
order by jumlah_bahasa desc
limit 10;

-- Tampilkan 10 nama negara (Name), bentuk pemerintahan (GovernmentForm), jumlah population semua negara (Population), persentase populasi tiap negara, serta nomor index baris tiap negara dari tabel Country!
SELECT name, GovernmentForm, 
SUM(population) OVER() AS world_population,
population*100/SUM(population) OVER() AS percentage,
ROW_NUMBER() OVER() AS row_index
FROM country
ORDER BY percentage DESC
LIMIT 10;

-- Tampilkan jumlah kota di tiap kawasan regional (Region)! Tampilkan hanya kawasan di Benua Asia dan Eropa, serta tambahkan nomor sesuai jumlah kawasan regional di tiap benua (Continent)! Gunakan tabel City dan Country! Perhatikan contoh hasilnya seperti di bawah ini!
WITH tabel1 AS (SELECT country.continent, country.region,
COUNT(city.name) AS number_of_city 
FROM country JOIN city ON country.code = city.countrycode
GROUP BY country.region)
SELECT *, ROW_NUMBER() OVER(PARTITION BY continent) AS row_group FROM tabel1
WHERE continent='Asia' OR continent='Europe'
ORDER BY continent
LIMIT 10;

/* Segmen konsumen yang potensial biasanya banyak tinggal di daerah ibukota negara. Meskipun, tidak menutup kemungkinan kota di luar ibukota juga mengalami perkembangan secara pesat, baik secara kuantitas pasar maupun daya beli konsumen.  
GNP suatu negara tidak sedikit yang disumbang perusahaan-perusahaan yang beroperasi di daerah ibukota. Terkadang pabriknya di luar ibukota, namun kantor pusatnya akan ditempatkan di ibukota. Sehingga, warga ibukota merupakan pasar potensial, karena banyak dari mereka yang bekerja di perusahaan-perusahaan besar penyumbang GNP nasional. Maka, GNP kurang lebih juga mencerminkan daya beli warga di ibukota suatu negara.  
Untuk menyusun strategi global, sebuah multinational company membutuhkan data peringkat benua berdasarkan jumlah populasi warga ibukota dan peringkat benua berdasarkan rata-rata GNP semua negara di benua tersebut.  
Tulis query SQL dari tabel yang tersedia database World untuk mendapatkan output tabel seperti di bawah ini! Menurut analisis Anda, benua manakah yang perlu diprioritaskan untuk pemasaran produk perusahaan?  */
WITH tabel1 AS (
    SELECT country.continent, SUM(city.population) AS total_capital_population, 
    AVG(country.gnp) AS avg_gnp FROM country 
    JOIN city ON country.capital=city.id GROUP BY country.continent)
SELECT *, 
RANK() OVER(ORDER BY total_capital_population DESC) AS Rank_population,
RANK() OVER(ORDER BY avg_gnp DESC) AS Rank_GNP
FROM tabel1
ORDER BY rank_population;

/* Perusahaan menugaskan Anda untuk mendapatkan output table seperti di bawah ini dari World Database. Tulis SQL query untuk menampilkan:  
* Nama negara prioritas,
* Persentase GNP tiap negara dibandingkan total GNP Global,
* Nilai kumulatif (Moving Sum) dari persentase GNP hanya sampai 80 persen saja,
* Peringkat berdasarkan persentase GNP, dan
* Kelompokkan negara-negara prioritas ini ke dalam 4 kelompok Market Priority!
* Tampilkan hanya negara-negara yang GNP-nya di atas satu persen!
*/
WITH tabel1 AS (
SELECT country.name AS country_name, 
country.gnp*100/SUM(country.gnp) OVER() AS gnp_percentage 
FROM country
ORDER BY gnp_percentage DESC
),
tabel2 AS (SELECT *, SUM(gnp_percentage) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS total_cumulative,
RANK() OVER(ORDER BY gnp_percentage DESC) AS gnp_rank
FROM tabel1)
SELECT *, NTILE(4) OVER(ORDER BY gnp_rank) AS quatile_cost 
FROM tabel2
WHERE gnp_percentage > 1;



