AS
BEGIN
SET NOCOUNT ON;
SELECT ID_CONTACT, GETDATE() AS DATE_PURGE, 'TISSOT' AS PROPRIETE
FROM TMP_TISSOT_CONTACT_PURGE
UNION
SELECT ID_CONTACT, GETDATE() AS DATE_PURGE, 'TI' AS PROPRIETE
FROM TMP_TI_CONTACT_PURGE
UNION
SELECT ID_CONTACT, GETDATE() AS DATE_PURGE, 'COMMUNDI' AS PROPRIETE
FROM TMP_COMUNDI_CONTACT_PURGE
UNION
SELECT ID_CONTACT, GETDATE() AS DATE_PURGE, 'WEKA' AS PROPRIETE
FROM TMP_WEKA_CONTACT_PURGE;

END