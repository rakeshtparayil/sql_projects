Download the csv file from this link and import the file. If using DB Browser SQLite, try to do it without any tutorials. In case you need any help, follow this video.


Questions
-- 9.1 Give the package name and how many times they're downloaded. Order by highest to lowest number of times downloaded.
-- 9.2 Give the package ranking (based on how many times it was downloaded) during 9AM to 11AM
-- 9.3 How many records (downloads) are from China ("CN") or Japan("JP") or Singapore ("SG")?
-- 9.4 Print the countries whose downloads are more than the downloads from China ("CN")
–-9.5 Print the length of each package name for packages which appear only once. 
-- In the same query, show the average length of all such packages.
-- 9.6 Get the package whose download count ranks 2nd (print package name and its download count).
-- 9.7 Print the name of the package whose download count is bigger than 1000.
-- 9.8 The field "r_os" is the operating system of the users.
-- Here we would like to know what main system we have (ignore version number), the relevant counts, and the proportion (in percentage).
--Hint: to write a query which can ignore the version number, try this: https://github.com/asg017/sqlite-regex)


-- 9.1 Give the package name and how many times they're downloaded. Order by highest to lowest number of times downloaded.
SELECT package, COUNT(package) AS download_count
FROM cran_logs
GROUP BY package
ORDER BY download_count DESC;

-- 9.2 Give the package ranking (based on how many times it was downloaded) during 9AM to 11AM
SELECT 
    package, 
    COUNT(package) AS download_count,
    RANK() OVER (ORDER BY COUNT(package) DESC) AS rank_column
FROM cran_logs
GROUP BY package;

-- 9.3 How many records (downloads) are from China ("CN") or Japan("JP") or Singapore ("SG")?
SELECT country, COUNT(*) AS count_per_country
FROM cran_logs
WHERE country IN ('JP', 'CN', 'SG')  
GROUP BY country;


-- 9.4 Print the countries whose downloads are more than the downloads from China ("CN")
WITH ChinaDownloads AS (
    SELECT COUNT(*) AS cn_downloads
    FROM cran_logs
    WHERE country = 'CN'
)
SELECT country, COUNT(*) AS total_downloads
FROM cran_logs, ChinaDownloads
GROUP BY country
HAVING COUNT(*) > cn_downloads;

– 9.5 Print the length of each package name for packages which appear only once. 
SELECT package, LENGTH(package) AS package_length
FROM cran_logs
GROUP BY package
HAVING COUNT(*) = 1;


-- In the same query, show the average length of all such packages.
WITH UniquePackages AS (
    SELECT package, LENGTH(package) AS package_length
    FROM cran_logs
    GROUP BY package
    HAVING COUNT(*) = 1
)
SELECT package, package_length, 
       (SELECT AVG(package_length) FROM UniquePackages) AS avg_package_length
FROM UniquePackages;

-- 9.6 Get the package whose download count ranks 2nd (print package name and its download count).
WITH PackageDownloadCounts AS (
    SELECT package, COUNT(*) AS download_count,
           RANK() OVER (ORDER BY COUNT(*) DESC) AS rank
    FROM cran_logs
    GROUP BY package
)
SELECT package, download_count
FROM PackageDownloadCounts
WHERE rank = 2;

-- 9.7 Print the name of the package whose download count is bigger than 1000.
SELECT package, COUNT(*) AS download_count
FROM cran_logs
GROUP BY package
HAVING COUNT(*) > 1000;

-- 9.8 The field "r_os" is the operating system of the users.
-- Here we would like to know what main system we have (ignore version number), the relevant counts, and the proportion (in percentage).
--Hint: to write a query which can ignore the version number, try this: https://github.com/asg017/sqlite-regex)

