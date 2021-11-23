AS
BEGIN


-- Chargement du thesaurus
-- Flux 74 
--- vidage de la table du thesaurus si on a plus d'un résultat et chargement du contenu de la table temporaire
IF (SELECT COUNT() FROM TMP_TI_THESAURUS
WHERE OPTI_REJECTED = 0 AND SIM_PARSELINE_RESULT=1 )<> 0
BEGIN;
	TRUNCATE TABLE DATA_TI_THESAURUS;
	
	INSERT INTO DATA_TI_THESAURUS (TAG_ID,TAG_LABEL)
	SELECT TAG_ID,TAG_LABEL FROM TMP_TI_THESAURUS
	WHERE OPTI_REJECTED = 0 AND SIM_PARSELINE_RESULT=1;
END;

-- chech temp table
IF OBJECT_ID('dbo.TMP_TISSOT_OPE_BEC', 'U') IS NOT NULL
BEGIN;
	TRUNCATE TABLE DATA_TI_THESAURUS;
	
	INSERT INTO DATA_TI_THESAURUS (TAG_ID,TAG_LABEL)
	SELECT TAG_ID,TAG_LABEL FROM TMP_TI_THESAURUS
	WHERE OPTI_REJECTED = 0 AND SIM_PARSELINE_RESULT=1
	
END;


-- chargement de l'association Thesaurus contenu 
-- FLUX 75 
-- table : TMP_TI_THESAURUS_CONTENT

IF (SELECT COUNT() FROM TMP_TI_THESAURUS_CONTENT
WHERE OPTI_REJECTED = 0 AND SIM_PARSELINE_RESULT=1 )<> 0
BEGIN;

TRUNCATE TABLE DATA_TI_THESAURUS_CONTENU;


-- insertion des correspondances pour les articles EDITO ACTU
INSERT INTO DATA_TI_THESAURUS_CONTENU (ID_ARTICLE,ORIGIN_ARTICLE,TAG_ID,ID_ARTICLE_SELLIGENT)
SELECT 
	TMP_TI_THESAURUS_CONTENT.ID_ARTICLE AS ID_ARTICLE,
	TMP_TI_THESAURUS_CONTENT.ORIGIN_ARTICLE AS ORIGIN_ARTICLE,
	TMP_TI_THESAURUS_CONTENT.TAG_ID AS TAG_ID,
	ARTICLES_TI_CONTENU_EDITO.ID AS ID_ARTICLE_SELLIGENT
FROM TMP_TI_THESAURUS_CONTENT
INNER JOIN ARTICLES_TI_CONTENU_EDITO ON TMP_TI_THESAURUS_CONTENT.ID_ARTICLE=ARTICLES_TI_CONTENU_EDITO.ID_ARTICLE
WHERE ORIGIN_ARTICLE=1

-- insertion des correspondances pour les articles INFOCOLL
INSERT INTO DATA_TI_THESAURUS_CONTENU (ID_ARTICLE,ORIGIN_ARTICLE,TAG_ID,ID_ARTICLE_SELLIGENT)
SELECT 
	TMP_TI_THESAURUS_CONTENT.ID_ARTICLE AS ID_ARTICLE,
	TMP_TI_THESAURUS_CONTENT.ORIGIN_ARTICLE AS ORIGIN_ARTICLE,
	TMP_TI_THESAURUS_CONTENT.TAG_ID AS TAG_ID,
	ARTICLES_TI_CONTENU_INFOCOLL.ID AS ID_ARTICLE_SELLIGENT
FROM TMP_TI_THESAURUS_CONTENT
INNER JOIN ARTICLES_TI_CONTENU_INFOCOLL ON TMP_TI_THESAURUS_CONTENT.ID_ARTICLE=ARTICLES_TI_CONTENU_INFOCOLL.ID_ARTICLE
WHERE ORIGIN_ARTICLE=0
END;


-- chargement de l'association Thesaurus USER 
-- FLUX 79 
-- table : TMP_TI_THESAURUS_USER
IF (SELECT COUNT() FROM TMP_TI_THESAURUS_CONTENT
WHERE OPTI_REJECTED = 0 AND SIM_PARSELINE_RESULT=1 )<> 0
BEGIN;

	TRUNCATE TABLE DATA_TI_THESAURUS_USERS;
	
	-- création des emails non existants 
	INSERT INTO USERS_TI_EMAILS
	(MAIL,CREATED_DT,MAIL_DOMAIN)
	SELECT DISTINCT
		TMP_TI_THESAURUS_USER.email_address,
		GETDATE(),
		SUBSTRING(TMP_TI_THESAURUS_USER.email_address,CHARINDEX ('@',TMP_TI_THESAURUS_USER.email_address)+1,1000)
	FROM TMP_TI_THESAURUS_USER
	WHERE NOT EXISTS (SELECT 1 FROM USERS_TI_EMAILS WHERE MAIL = TMP_TI_THESAURUS_USER.email_address);
	
	
	-- insertion des correspondances emails/thesaurus
	INSERT INTO DATA_TI_THESAURUS_USERS (MAIL_CODE,TAG_ID)
	SELECT USERS_TI_EMAILS.ID, TAG_ID
	FROM TMP_TI_THESAURUS_USER
	INNER JOIN USERS_TI_EMAILS ON USERS_TI_EMAILS.MAIL = TMP_TI_THESAURUS_USER.email_address

END;

END