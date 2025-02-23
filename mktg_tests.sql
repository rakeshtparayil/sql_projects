CREATE VIEW AdPerformanceView AS
SELECT 
    C.Campaign_ID,
    C.Campaign_Name,
    A.Adgroup_ID,
    A.Adgroup_Name,
    Ads.Creative_ID,
    Ads.Ad_Name,
    Ads.Impressions,
    Ads.Clicks,
    Ads.CTR,
    Ads.Reach,
    Ads.Cost,
    Ads.CPM,
    Ads.Installs
FROM Ads
JOIN AdGroups A ON Ads.Adgroup_ID = A.Adgroup_ID
JOIN Campaigns C ON A.Campaign_ID = C.Campaign_ID;


-- 
SELECT * FROM ads

