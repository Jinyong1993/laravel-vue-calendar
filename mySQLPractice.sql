-- 1
-- 테이블에서 생일이 3월인 여성 회원의 ID, 이름, 성별, 생년월일을 조회하는 SQL문을 작성해주세요.
-- 이때 전화번호가 NULL인 경우는 출력대상에서 제외시켜 주시고,
-- 결과는 회원ID를 기준으로 오름차순 정렬해주세요.
SELECT *
FROM MEMBER_PROFILE
WHERE MONTH(DATE_OF_BIRTH) = '3' AND TLNO IS NOT NULL AND GENDER = 'W'
ORDER BY MEMBER_ID DESC;

-- 2022년 10월에 작성된 게시글 제목, 게시글 ID, 댓글 ID,
-- 댓글 작성자 ID, 댓글 내용, 댓글 작성일을 조회하는 SQL문을 작성해주세요.
-- 결과는 댓글 작성일을 기준으로 오름차순 정렬해주시고,
-- 댓글 작성일이 같다면 게시글 제목을 기준으로 오름차순 정렬해주세요.
SELECT
A.TITLE,
A.BOARD_ID,
B.REPLY_ID,
B.WRITER_ID,
B.CONTENTS,
DATE_FORMAT(B.CREATED_DATE, '%Y-%m-%d') AS CREATED_DATE
FROM USED_GOODS_BOARD AS A
INNER JOIN USED_GOODS_REPLY AS B
ON A.BOARD_ID = B.BOARD_ID
WHERE DATE_FORMAT(A.CREATED_DATE, '%Y-%m') = '2022-10'
ORDER BY B.CREATED_DATE ASC, A.TITLE ASC

-- CAR_RENTAL_COMPANY_RENTAL_HISTORY 테이블에서
-- 2022년 10월 16일에 대여 중인 자동차인 경우 '대여중' 이라고 표시하고,
-- 대여 중이지 않은 자동차인 경우 '대여 가능'을 표시하는 컬럼(컬럼명: AVAILABILITY)을 추가하여
-- 자동차 ID와 AVAILABILITY 리스트를 출력하는 SQL문을 작성해주세요.
-- 이때 반납 날짜가 2022년 10월 16일인 경우에도 '대여중'으로 표시해주시고
-- 결과는 자동차 ID를 기준으로 내림차순 정렬해주세요.
SELECT CAR_ID,
(CASE
    WHEN MAX('2022-10-16' BETWEEN START_DATE AND END_DATE) THEN '대여중'
    ELSE '대여 가능'
END) AS AVAILABILITY
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
GROUP BY CAR_ID
ORDER BY CAR_ID DESC


-- 2
-- FOOD_FACTORY 테이블에서 강원도에 위치한 식품공장의 공장 ID, 공장 이름, 주소를 조회하는 SQL문을 작성해주세요.
-- 이때 결과는 공장 ID를 기준으로 오름차순 정렬해주세요.
SELECT FACTORY_ID, FACTORY_NAME, ADDRESS
FROM FOOD_FACTORY
WHERE ADDRESS LIKE '강원도%'
ORDER BY FACTORY_ID ASC

-- DOCTOR 테이블에서 진료과가 흉부외과(CS)이거나 일반외과(GS)인 의사의 이름, 의사ID, 진료과, 고용일자를 조회하는 SQL문을 작성해주세요.
-- 이때 결과는 고용일자를 기준으로 내림차순 정렬하고, 고용일자가 같다면 이름을 기준으로 오름차순 정렬해주세요.
SELECT DR_NAME, DR_ID, MCDP_CD, DATE_FORMAT(HIRE_YMD, '%Y-%m-%d') as HIRE_YMD
FROM DOCTOR
WHERE MCDP_CD = 'CS' OR MCDP_CD = 'GS'
ORDER BY HIRE_YMD DESC, DR_NAME ASC

-- BOOK 테이블에서 2021년에 출판된 '인문' 카테고리에 속하는 도서 리스트를 찾아서 도서 ID(BOOK_ID),
-- 출판일 (PUBLISHED_DATE)을 출력하는 SQL문을 작성해주세요. 결과는 출판일을 기준으로 오름차순 정렬해주세요.
SELECT BOOK_ID, DATE_FORMAT(PUBLISHED_DATE, '%Y-%m-%d') as PUBLISHED_DATE
FROM BOOK
WHERE PUBLISHED_DATE LIKE '2021%' AND CATEGORY = '인문'
ORDER BY PUBLISHED_DATE ASC

-- CAR_RENTAL_COMPANY_CAR 테이블에서 자동차 종류가 'SUV'인 자동차들의 평균 일일 대여 요금을 출력하는 SQL문을 작성해주세요.
-- 이때 평균 일일 대여 요금은 소수 첫 번째 자리에서 반올림하고, 컬럼명은 AVERAGE_FEE 로 지정해주세요.
SELECT ROUND(SUM(DAILY_FEE) / COUNT(DAILY_FEE)) AS AVERAGE_FEE
FROM CAR_RENTAL_COMPANY_CAR
WHERE CAR_TYPE = 'SUV'

-- 상반기 아이스크림 총주문량이 3,000보다 높으면서 아이스크림의 주 성분이 과일인 아이스크림의 맛을
-- 총주문량이 큰 순서대로 조회하는 SQL 문을 작성해주세요.
SELECT A.FLAVOR
FROM FIRST_HALF AS A
INNER JOIN ICECREAM_INFO AS B
ON A.FLAVOR = B.FLAVOR
WHERE A.TOTAL_ORDER >= 3000 AND B.INGREDIENT_TYPE = 'fruit_based'
ORDER BY A.TOTAL_ORDER DESC

-- PATIENT 테이블에서 12세 이하인 여자환자의 환자이름, 환자번호, 성별코드, 나이, 전화번호를 조회하는 SQL문을 작성해주세요.
-- 이때 전화번호가 없는 경우, 'NONE'으로 출력시켜 주시고 결과는 나이를 기준으로 내림차순 정렬하고,
-- 나이 같다면 환자이름을 기준으로 오름차순 정렬해주세요.
SELECT PT_NAME, PT_NO, GEND_CD, AGE, IFNULL(TLNO, 'NONE') AS TLNO
FROM PATIENT
WHERE AGE <= 12 AND GEND_CD = 'W'
ORDER BY AGE DESC, PT_NAME ASC

-- 상반기에 판매된 아이스크림의 맛을 총주문량을 기준으로 내림차순 정렬하고
-- 총주문량이 같다면 출하 번호를 기준으로 오름차순 정렬하여 조회하는 SQL 문을 작성해주세요.
SELECT FLAVOR
FROM FIRST_HALF
ORDER BY TOTAL_ORDER DESC, SHIPMENT_ID ASC

-- 동물 보호소에 들어온 모든 동물의 정보를 ANIMAL_ID순으로 조회하는 SQL문을 작성해주세요.
SELECT *
FROM ANIMAL_INS
ORDER BY ANIMAL_ID

-- 동물 보호소에 들어온 모든 동물의 이름과 보호 시작일을 조회하는 SQL문을 작성해주세요.
-- 이때 결과는 ANIMAL_ID 역순으로 보여주세요.
SELECT NAME, DATETIME
FROM ANIMAL_INS
ORDER BY ANIMAL_ID DESC

-- 동물 보호소에 들어온 동물 중 아픈 동물1의 아이디와 이름을 조회하는 SQL 문을 작성해주세요.
-- 이때 결과는 아이디 순으로 조회해주세요.
SELECT ANIMAL_ID, NAME
FROM ANIMAL_INS
WHERE INTAKE_CONDITION = 'Sick'
ORDER BY ANIMAL_ID

-- 동물 보호소에 들어온 모든 동물의 아이디와 이름, 보호 시작일을 이름 순으로 조회하는 SQL문을 작성해주세요.
-- 단, 이름이 같은 동물 중에서는 보호를 나중에 시작한 동물을 먼저 보여줘야 합니다.
SELECT ANIMAL_ID, NAME, DATETIME
FROM ANIMAL_INS
ORDER BY NAME ASC, DATETIME DESC

-- USER_INFO 테이블에서 2021년에 가입한 회원 중
-- 나이가 20세 이상 29세 이하인 회원이 몇 명인지 출력하는 SQL문을 작성해주세요.
SELECT COUNT(USER_ID) AS USERS
FROM USER_INFO
WHERE JOINED BETWEEN '2021-01-01' AND '2021-12-31' AND AGE BETWEEN 20 AND 29



-- 1
-- ONLINE_SALE 테이블에서 동일한 회원이 동일한 상품을 재구매한 데이터를 구하여,
-- 재구매한 회원 ID와 재구매한 상품 ID를 출력하는 SQL문을 작성해주세요.
-- 결과는 회원 ID를 기준으로 오름차순 정렬해주시고 회원 ID가 같다면 상품 ID를 기준으로 내림차순 정렬해주세요.
SELECT USER_ID, PRODUCT_ID
FROM ONLINE_SALE
GROUP BY PRODUCT_ID, USER_ID
HAVING COUNT(USER_ID) > 1
ORDER BY USER_ID ASC, PRODUCT_ID DESC

-- REST_INFO와 REST_REVIEW 테이블에서 서울에 위치한 식당들의 식당 ID, 식당 이름,
-- 음식 종류, 즐겨찾기수, 주소, 리뷰 평균 점수를 조회하는 SQL문을 작성해주세요.
-- 이때 리뷰 평균점수는 소수점 세 번째 자리에서 반올림 해주시고
-- 결과는 평균점수를 기준으로 내림차순 정렬해주시고, 평균점수가 같다면 즐겨찾기수를 기준으로 내림차순 정렬해주세요.
SELECT A.REST_ID, A.REST_NAME, A.FOOD_TYPE, A.FAVORITES, A.ADDRESS, ROUND(AVG(B.REVIEW_SCORE), 2) AS SCORE
FROM REST_INFO AS A
INNER JOIN REST_REVIEW AS B
ON A.REST_ID = B.REST_ID
WHERE A.ADDRESS LIKE '서울%'
GROUP BY A.REST_ID
ORDER BY SCORE DESC, A.FAVORITES DESC

-- ONLINE_SALE 테이블과 OFFLINE_SALE 테이블에서 2022년 3월의 오프라인/온라인 상품 판매 데이터의 판매 날짜,
-- 상품ID, 유저ID, 판매량을 출력하는 SQL문을 작성해주세요.
-- OFFLINE_SALE 테이블의 판매 데이터의 USER_ID 값은 NULL 로 표시해주세요.
-- 결과는 판매일을 기준으로 오름차순 정렬해주시고
-- 판매일이 같다면 상품 ID를 기준으로 오름차순, 상품ID까지 같다면 유저 ID를 기준으로 오름차순 정렬해주세요.
SELECT DATE_FORMAT(SALES_DATE, '%Y-%m-%d') AS SALES_DATE, PRODUCT_ID, USER_ID, SALES_AMOUNT
FROM ONLINE_SALE
WHERE SALES_DATE BETWEEN '2022-03-01' AND '2022-03-31'
UNION ALL
SELECT DATE_FORMAT(SALES_DATE, '%Y-%m-%d') AS SALES_DATE, PRODUCT_ID, NULL AS USER_ID, SALES_AMOUNT
FROM OFFLINE_SALE
WHERE SALES_DATE BETWEEN '2022-03-01' AND '2022-03-31'
ORDER BY SALES_DATE, PRODUCT_ID, USER_ID

-- PRODUCT 테이블에서 판매 중인 상품 중 가장 높은 판매가를 출력하는 SQL문을 작성해주세요.
-- 이때 컬럼명은 MAX_PRICE로 지정해주세요.
SELECT MAX(PRICE) AS MAX_PRICE
FROM PRODUCT

-- 가장 최근에 들어온 동물은 언제 들어왔는지 조회하는 SQL 문을 작성해주세요.
SELECT MAX(DATETIME) AS DATETIME
FROM ANIMAL_INS

-- 동물 보호소에 가장 먼저 들어온 동물은 언제 들어왔는지 조회하는 SQL 문을 작성해주세요.
SELECT MIN(DATETIME) AS DATETIME
FROM ANIMAL_INS

-- FOOD_PRODUCT 테이블에서 가격이 제일 비싼 식품의
-- 식품 ID, 식품 이름, 식품 코드, 식품분류, 식품 가격을 조회하는 SQL문을 작성해주세요.
SELECT PRODUCT_ID, PRODUCT_NAME, PRODUCT_CD, CATEGORY, PRICE
FROM FOOD_PRODUCT
ORDER BY PRICE DESC
LIMIT 1

-- 동물 보호소에 동물이 몇 마리 들어왔는지 조회하는 SQL 문을 작성해주세요.
SELECT COUNT(ANIMAL_ID) AS count
FROM ANIMAL_INS

-- 동물 보호소에 들어온 동물의 이름은 몇 개인지 조회하는 SQL 문을 작성해주세요.
-- 이때 이름이 NULL인 경우는 집계하지 않으며 중복되는 이름은 하나로 칩니다.
SELECT COUNT(distinct(NAME)) AS COUNT
FROM ANIMAL_INS
WHERE NAME IS NOT NULL


-- 2
-- 상반기 동안 각 아이스크림 성분 타입과 성분 타입에 대한 아이스크림의 총주문량을 총주문량이
-- 작은 순서대로 조회하는 SQL 문을 작성해주세요.
-- 이때 총주문량을 나타내는 컬럼명은 TOTAL_ORDER로 지정해주세요.
SELECT INGREDIENT_TYPE, SUM(TOTAL_ORDER) AS TOTAL_ORDER
FROM FIRST_HALF AS A
INNER JOIN ICECREAM_INFO AS B
ON A.FLAVOR = B.FLAVOR
GROUP BY INGREDIENT_TYPE

-- CAR_RENTAL_COMPANY_CAR 테이블에서 '통풍시트', '열선시트', '가죽시트' 중
-- 하나 이상의 옵션이 포함된 자동차가 자동차 종류 별로 몇 대인지 출력하는 SQL문을 작성해주세요.
-- 이때 자동차 수에 대한 컬럼명은 CARS로 지정하고,
-- 결과는 자동차 종류를 기준으로 오름차순 정렬해주세요.
SELECT CAR_TYPE, COUNT(CAR_TYPE) AS CARS
FROM CAR_RENTAL_COMPANY_CAR
WHERE OPTIONS LIKE '%통풍시트%' OR OPTIONS LIKE '%열선시트%' OR OPTIONS LIKE '%가죽시트%'
GROUP BY CAR_TYPE
ORDER BY CAR_TYPE

-- APPOINTMENT 테이블에서 2022년 5월에 예약한 환자 수를 진료과코드 별로 조회하는 SQL문을 작성해주세요.
-- 이때, 컬럼명은 '진료과 코드', '5월예약건수'로 지정해주시고
-- 결과는 진료과별 예약한 환자 수를 기준으로 오름차순 정렬하고,
-- 예약한 환자 수가 같다면 진료과 코드를 기준으로 오름차순 정렬해주세요.
SELECT MCDP_CD AS '진료과 코드', COUNT(APNT_YMD) AS '5월예약건수'
FROM APPOINTMENT
WHERE APNT_YMD BETWEEN '2022-05-01' AND '2022-05-31'
GROUP BY MCDP_CD
ORDER BY 2, 1

-- 동물 보호소에 들어온 동물 중 고양이와 개가 각각 몇 마리인지 조회하는 SQL문을 작성해주세요.
-- 이때 고양이를 개보다 먼저 조회해주세요.
SELECT ANIMAL_TYPE, COUNT(ANIMAL_TYPE) AS COUNT
FROM ANIMAL_INS
WHERE ANIMAL_TYPE LIKE 'Cat' OR ANIMAL_TYPE LIKE 'Dog'
GROUP BY ANIMAL_TYPE
ORDER BY ANIMAL_TYPE

-- 동물 보호소에 들어온 동물 이름 중 두 번 이상 쓰인 이름과 해당 이름이 쓰인 횟수를 조회하는 SQL문을 작성해주세요.
-- 이때 결과는 이름이 없는 동물은 집계에서 제외하며, 결과는 이름 순으로 조회해주세요.
SELECT NAME, COUNT(NAME) AS COUNT
FROM ANIMAL_INS
WHERE NAME IS NOT NULL
GROUP BY NAME
HAVING COUNT(NAME) >= 2
ORDER BY NAME

-- 보호소에서는 몇 시에 입양이 가장 활발하게 일어나는지 알아보려 합니다.
-- 09:00부터 19:59까지, 각 시간대별로 입양이 몇 건이나 발생했는지 조회하는 SQL문을 작성해주세요.
-- 이때 결과는 시간대 순으로 정렬해야 합니다.
SELECT DATE_FORMAT(DATETIME, '%H') AS HOUR, COUNT(DATETIME) AS COUNT
FROM ANIMAL_OUTS
GROUP BY HOUR
HAVING HOUR >= 09 AND HOUR <= 19
ORDER BY HOUR ASC

-- PRODUCT 테이블에서 만원 단위의 가격대 별로 상품 개수를 출력하는 SQL 문을 작성해주세요.
-- 이때 컬럼명은 각각 컬럼명은 PRICE_GROUP, PRODUCTS로 지정해주시고
-- 가격대 정보는 각 구간의 최소금액(10,000원 이상 ~ 20,000 미만인 구간인 경우 10,000)으로 표시해주세요.
-- 결과는 가격대를 기준으로 오름차순 정렬해주세요.
SELECT (PRICE DIV 10000) * 10000 AS PRICE_GROUP, COUNT(*) AS COUNT
FROM PRODUCT
GROUP BY PRICE_GROUP
ORDER BY PRICE_GROUP

-- REST_INFO 테이블에서 음식종류별로 즐겨찾기수가 가장 많은
-- 식당의 음식 종류, ID, 식당 이름, 즐겨찾기수를 조회하는 SQL문을 작성해주세요.
-- 이때 결과는 음식 종류를 기준으로 내림차순 정렬해주세요.
SELECT r1.FOOD_TYPE, r1.REST_ID, r1.REST_NAME, r1.FAVORITES
FROM REST_INFO r1
LEFT JOIN REST_INFO r2
ON r1.FAVORITES < r2.FAVORITES AND r1.FOOD_TYPE = r2.FOOD_TYPE
WHERE r2.REST_ID IS NULL
ORDER BY r1.FOOD_TYPE DESC

-- USED_GOODS_BOARD와 USED_GOODS_USER 테이블에서 완료된
-- 중고 거래의 총금액이 70만 원 이상인 사람의 회원 ID, 닉네임, 총거래금액을
-- 조회하는 SQL문을 작성해주세요. 결과는 총거래금액을 기준으로 오름차순 정렬해주세요.
SELECT B.USER_ID, B.NICKNAME, SUM(A.PRICE) AS TOTAL_SALES
FROM USED_GOODS_BOARD AS A
JOIN USED_GOODS_USER AS B
ON A.WRITER_ID = B.USER_ID
WHERE A.STATUS = 'DONE'
GROUP BY B.USER_ID
HAVING TOTAL_SALES >= 700000
ORDER BY TOTAL_SALES

-- 2022년 1월의 카테고리 별 도서 판매량을 합산하고, 카테고리(CATEGORY), 총 판매량(TOTAL_SALES)
-- 리스트를 출력하는 SQL문을 작성해주세요.
-- 결과는 카테고리명을 기준으로 오름차순 정렬해주세요.
SELECT CATEGORY, SUM(SALES) AS TOTAL_SALES
FROM BOOK AS A
INNER JOIN BOOK_SALES AS B
ON A.BOOK_ID = B.BOOK_ID
WHERE B.SALES_DATE BETWEEN '2022-01-01' AND '2022-01-31'
GROUP BY CATEGORY
ORDER BY CATEGORY



-- 1　202/06/23
-- CAR_RENTAL_COMPANY_RENTAL_HISTORY 테이블에서 대여 시작일을 기준으로
-- 2022년 8월부터 2022년 10월까지 총 대여 횟수가 5회 이상인 자동차들에 대해서
-- 해당 기간 동안의 월별 자동차 ID 별 총 대여 횟수(컬럼명: RECORDS) 리스트를 출력하는 SQL문을 작성해주세요.
-- 결과는 월을 기준으로 오름차순 정렬하고, 월이 같다면 자동차 ID를 기준으로 내림차순 정렬해주세요.
-- 특정 월의 총 대여 횟수가 0인 경우에는 결과에서 제외해주세요.
SELECT MONTH(START_DATE) AS MONTH, CAR_ID, COUNT(HISTORY_ID) AS RECORDS
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
WHERE MONTH(START_DATE) BETWEEN 8 AND 10
AND CAR_ID IN (
    SELECT CAR_ID
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
    WHERE MONTH(START_DATE) BETWEEN 8 AND 10
    GROUP BY CAR_ID
    HAVING COUNT(CAR_ID) >= 5)
GROUP BY MONTH(START_DATE), CAR_ID
ORDER BY MONTH, CAR_ID DESC

-- 2
-- 2022년 1월의 도서 판매 데이터를 기준으로 저자 별,
-- 카테고리 별 매출액(TOTAL_SALES = 판매량 * 판매가) 을 구하여,
-- 저자 ID(AUTHOR_ID), 저자명(AUTHOR_NAME), 카테고리(CATEGORY), 매출액(SALES) 리스트를 출력하는 SQL문을 작성해주세요.
-- 결과는 저자 ID를 오름차순으로, 저자 ID가 같다면 카테고리를 내림차순 정렬해주세요.
SELECT T2.AUTHOR_ID, T1.AUTHOR_NAME, T2.CATEGORY, SUM(T2.TOTAL_SALES) AS TOTAL_SALES
FROM AUTHOR AS T1
INNER JOIN
(
    SELECT B.AUTHOR_ID, B.CATEGORY, (B.PRICE * S.SALES) AS TOTAL_SALES
    FROM BOOK_SALES AS S
    INNER JOIN BOOK AS B
    ON B.BOOK_ID = S.BOOK_ID
    WHERE S.SALES_DATE LIKE '2022-01%'
) AS T2
ON T1.AUTHOR_ID = T2.AUTHOR_ID
GROUP BY T2.AUTHOR_ID, T1.AUTHOR_NAME, T2.CATEGORY
ORDER BY T2.AUTHOR_ID, T2.CATEGORY DESC

-- FOOD_PRODUCT 테이블에서 식품분류별로 가격이 제일 비싼 식품의 분류, 가격, 이름을 조회하는 SQL문을 작성해주세요.
-- 이때 식품분류가 '과자', '국', '김치', '식용유'인 경우만 출력시켜 주시고 결과는 식품 가격을 기준으로 내림차순 정렬해주세요.
SELECT CATEGORY, PRICE AS MAX_PRICE, PRODUCT_NAME
FROM FOOD_PRODUCT
WHERE (CATEGORY, PRICE) IN
(
    SELECT CATEGORY, MAX(PRICE)
    FROM FOOD_PRODUCT
    GROUP BY CATEGORY
    HAVING CATEGORY IN ('과자', '국', '김치', '식용유')
)
ORDER BY MAX_PRICE DESC

-- FOOD_WAREHOUSE 테이블에서 경기도에 위치한 창고의 ID, 이름, 주소, 냉동시설 여부를 조회하는 SQL문을 작성해주세요.
-- 이때 냉동시설 여부가 NULL인 경우, 'N'으로 출력시켜 주시고 결과는 창고 ID를 기준으로 오름차순 정렬해주세요.
SELECT WAREHOUSE_ID, WAREHOUSE_NAME, ADDRESS, IFNULL(FREEZER_YN, 'N') AS FREEZER_YN
FROM FOOD_WAREHOUSE
WHERE ADDRESS LIKE '경기도%'
ORDER BY WAREHOUSE_ID

-- 동물 보호소에 들어온 동물 중, 이름이 없는 채로 들어온 동물의 ID를 조회하는 SQL 문을 작성해주세요.
-- 단, ID는 오름차순 정렬되어야 합니다.
SELECT ANIMAL_ID
FROM ANIMAL_INS
WHERE NAME IS NULL
ORDER BY ANIMAL_ID

-- 동물 보호소에 들어온 동물 중, 이름이 있는 동물의 ID를 조회하는 SQL 문을 작성해주세요.
-- 단, ID는 오름차순 정렬되어야 합니다.
SELECT ANIMAL_ID
FROM ANIMAL_INS
WHERE NAME IS NOT NULL
ORDER BY ANIMAL_ID

-- 입양 게시판에 동물 정보를 게시하려 합니다.
-- 동물의 생물 종, 이름, 성별 및 중성화 여부를 아이디 순으로 조회하는 SQL문을 작성해주세요.
-- 이때 프로그래밍을 모르는 사람들은 NULL이라는 기호를 모르기 때문에,
-- 이름이 없는 동물의 이름은 "No name"으로 표시해 주세요.
SELECT ANIMAL_TYPE, IFNULL(NAME, 'No name') AS NAME, SEX_UPON_INTAKE
FROM ANIMAL_INS

-- USER_INFO 테이블에서 나이 정보가 없는 회원이 몇 명인지 출력하는 SQL문을 작성해주세요.
-- 이때 컬럼명은 USERS로 지정해주세요.
SELECT COUNT(*) AS USERS
FROM USER_INFO
WHERE AGE IS NULL

-- USED_GOODS_BOARD 테이블에서 2022년 10월 5일에 등록된 중고거래 게시물의
-- 게시글 ID, 작성자 ID, 게시글 제목, 가격, 거래상태를 조회하는 SQL문을 작성해주세요.
-- 거래상태가 SALE 이면 판매중, RESERVED이면 예약중, DONE이면 거래완료 분류하여 출력해주시고,
-- 결과는 게시글 ID를 기준으로 내림차순 정렬해주세요.
SELECT BOARD_ID, WRITER_ID, TITLE, PRICE,
(
    CASE
        WHEN STATUS = 'SALE' THEN '판매중'
        WHEN STATUS = 'RESERVED' THEN '예약중'
        ELSE '거래완료'
    END
) AS STATUS
FROM USED_GOODS_BOARD
WHERE CREATED_DATE = '2022-10-05'
ORDER BY BOARD_ID DESC

-- CAR_RENTAL_COMPANY_RENTAL_HISTORY 테이블에서 평균 대여 기간이
-- 7일 이상인 자동차들의 자동차 ID와 평균 대여 기간(컬럼명: AVERAGE_DURATION) 리스트를 출력하는 SQL문을 작성해주세요.
-- 평균 대여 기간은 소수점 두번째 자리에서 반올림하고,
-- 결과는 평균 대여 기간을 기준으로 내림차순 정렬해주시고,
-- 평균 대여 기간이 같으면 자동차 ID를 기준으로 내림차순 정렬해주세요.
SELECT CAR_ID, ROUND(AVG(DATEDIFF(END_DATE, START_DATE) + 1), 1) AS AVERAGE_DURATION
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
GROUP BY CAR_ID
HAVING AVERAGE_DURATION >= 7
ORDER BY AVERAGE_DURATION DESC, CAR_ID DESC

-- CAR_RENTAL_COMPANY_RENTAL_HISTORY 테이블에서 대여 시작일이
-- 2022년 9월에 속하는 대여 기록에 대해서 대여 기간이 30일 이상이면 '장기 대여'
-- 그렇지 않으면 '단기 대여' 로 표시하는 컬럼(컬럼명: RENT_TYPE)을 추가하여
-- 대여기록을 출력하는 SQL문을 작성해주세요. 결과는 대여 기록 ID를 기준으로 내림차순 정렬해주세요.
SELECT HISTORY_ID, CAR_ID,
DATE_FORMAT(START_DATE, '%Y-%m-%d') AS START_DATE,
DATE_FORMAT(END_DATE, '%Y-%m-%d') AS END_DATE,
(
    CASE
        WHEN DATEDIFF(END_DATE, START_DATE) + 1 >= 30 THEN '장기 대여'
        ELSE '단기 대여'
    END
) AS RENT_TYPE
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
WHERE YEAR(START_DATE) = 2022 AND MONTH(START_DATE) = 9
ORDER BY HISTORY_ID DESC

-- CAR_RENTAL_COMPANY_CAR 테이블에서 '네비게이션' 옵션이 포함된
-- 자동차 리스트를 출력하는 SQL문을 작성해주세요. 결과는 자동차 ID를 기준으로 내림차순 정렬해주세요.
SELECT CAR_ID, CAR_TYPE, DAILY_FEE, OPTIONS
FROM CAR_RENTAL_COMPANY_CAR
WHERE OPTIONS LIKE '%네비게이션%'
ORDER BY CAR_ID DESC

-- 동물 보호소에 들어온 동물 중 이름이 Lucy, Ella, Pickle, Rogan, Sabrina, Mitty인
-- 동물의 아이디와 이름, 성별 및 중성화 여부를 조회하는 SQL 문을 작성해주세요.
SELECT ANIMAL_ID, NAME, SEX_UPON_INTAKE
FROM ANIMAL_INS
WHERE NAME IN ('Lucy', 'Ella', 'Pickle', 'Rogan', 'Sabrina', 'Mitty')
ORDER BY ANIMAL_ID

-- 보호소에 돌아가신 할머니가 기르던 개를 찾는 사람이 찾아왔습니다.
-- 이 사람이 말하길 할머니가 기르던 개는 이름에 'el'이 들어간다고 합니다.
-- 동물 보호소에 들어온 동물 이름 중,
-- 이름에 "EL"이 들어가는 개의 아이디와 이름을 조회하는 SQL문을 작성해주세요.
-- 이때 결과는 이름 순으로 조회해주세요. 단, 이름의 대소문자는 구분하지 않습니다.
SELECT ANIMAL_ID, NAME
FROM ANIMAL_INS
WHERE NAME LIKE '%el%' AND ANIMAL_TYPE = 'DOG'
ORDER BY NAME

-- 보호소의 동물이 중성화되었는지 아닌지 파악하려 합니다.
-- 중성화된 동물은 SEX_UPON_INTAKE 컬럼에 'Neutered' 또는 'Spayed'라는 단어가 들어있습니다.
-- 동물의 아이디와 이름, 중성화 여부를 아이디 순으로 조회하는 SQL문을 작성해주세요.
-- 이때 중성화가 되어있다면 'O', 아니라면 'X'라고 표시해주세요.
SELECT ANIMAL_ID, NAME,
(
    CASE
        WHEN SEX_UPON_INTAKE LIKE '%Neutered%' THEN 'O'
        WHEN SEX_UPON_INTAKE LIKE '%Spayed%' THEN 'O'
        ELSE 'X'
    END
) AS '중성화'
FROM ANIMAL_INS
ORDER BY ANIMAL_ID

-- PRODUCT 테이블에서 상품 카테고리 코드(PRODUCT_CODE 앞 2자리) 별 상품 개수를
-- 출력하는 SQL문을 작성해주세요. 결과는 상품 카테고리 코드를 기준으로 오름차순 정렬해주세요.
SELECT LEFT(PRODUCT_CODE, 2) AS CATEGORY, COUNT(LEFT(PRODUCT_CODE, 2)) AS PRODUCT
FROM PRODUCT
GROUP BY CATEGORY
ORDER BY CATEGORY

-- ANIMAL_INS 테이블에 등록된 모든 레코드에 대해,
-- 각 동물의 아이디와 이름, 들어온 날짜1를 조회하는 SQL문을 작성해주세요.
-- 이때 결과는 아이디 순으로 조회해야 합니다.
SELECT ANIMAL_ID, NAME, DATE_FORMAT(DATETIME, '%Y-%m-%d') AS '날짜'
FROM ANIMAL_INS
ORDER BY ANIMAL_ID

-- 10월에 대여를 시작한 기록이 있는 '세단' 종류의 자동차는 자동차 ID가 1, 3 인 자동차이고,
-- 자동차 ID를 기준으로 내림차순 정렬하면 다음과 같이 나와야 합니다.
SELECT T1.CAR_ID
FROM CAR_RENTAL_COMPANY_CAR AS T1
INNER JOIN CAR_RENTAL_COMPANY_RENTAL_HISTORY AS T2
ON T1.CAR_ID = T2.CAR_ID
WHERE T1.CAR_TYPE LIKE '세단' AND MONTH(START_DATE) = 10
GROUP BY T1.CAR_ID
ORDER BY T1.CAR_ID DESC

-- FOOD_ORDER 테이블에서 5월 1일을 기준으로 주문 ID, 제품 ID, 출고일자, 출고여부를 조회하는 SQL문을 작성해주세요.
-- 출고여부는 5월 1일까지 출고완료로 이 후 날짜는 출고 대기로 미정이면 출고미정으로 출력해주시고,
-- 결과는 주문 ID를 기준으로 오름차순 정렬해주세요.
SELECT ORDER_ID, PRODUCT_ID, DATE_FORMAT(OUT_DATE, '%Y-%m-%d') AS OUT_DATE,
(
    CASE
        WHEN OUT_DATE <= '2022-05-01 00:00:00' THEN '출고완료'
        WHEN OUT_DATE > '2022-05-01 00:00:00' THEN '출고대기'
        ELSE '출고미정'
    END
) AS '출고여부'
FROM FOOD_ORDER
ORDER BY ORDER_ID

-- USED_GOODS_BOARD와 USED_GOODS_FILE 테이블에서 조회수가 가장 높은
-- 중고거래 게시물에 대한 첨부파일 경로를 조회하는 SQL문을 작성해주세요.
-- 첨부파일 경로는 FILE ID를 기준으로 내림차순 정렬해주세요.
-- 기본적인 파일경로는 /home/grep/src/ 이며, 게시글 ID를 기준으로 디렉토리가 구분되고,
-- 파일이름은 파일 ID, 파일 이름, 파일 확장자로 구성되도록 출력해주세요.
-- 조회수가 가장 높은 게시물은 하나만 존재합니다.
SELECT CONCAT('/home/grep/src/', T1.BOARD_ID, '/', T2.FILE_ID, T2.FILE_NAME, T2.FILE_EXT) AS FILE_PATH
FROM USED_GOODS_BOARD AS T1
JOIN USED_GOODS_FILE AS T2
ON T1.BOARD_ID = T2.BOARD_ID
WHERE VIEWS IN
(
    SELECT MAX(VIEWS)
    FROM USED_GOODS_BOARD
)
ORDER BY T2.FILE_ID DESC

-- USED_GOODS_BOARD와 USED_GOODS_USER 테이블에서 중고 거래 게시물을 3건 이상 등록한
-- 사용자의 사용자 ID, 닉네임, 전체주소, 전화번호를 조회하는 SQL문을 작성해주세요.
-- 이때, 전체 주소는 시, 도로명 주소, 상세 주소가 함께 출력되도록 해주시고,
-- 전화번호의 경우 xxx-xxxx-xxxx 같은 형태로 하이픈 문자열(-)을 삽입하여 출력해주세요.
-- 결과는 회원 ID를 기준으로 내림차순 정렬해주세요.
SELECT USER_ID, NICKNAME,
CONCAT_WS(' ', CITY, STREET_ADDRESS1, STREET_ADDRESS2) AS '전체주소',
CONCAT_WS('-', SUBSTRING(TLNO, 1, 3), SUBSTRING(TLNO, 4, 4), SUBSTRING(TLNO, 8, 4)) AS '전화번호'
FROM USED_GOODS_BOARD AS T1
JOIN USED_GOODS_USER AS T2
ON T1.WRITER_ID = T2.USER_ID
GROUP BY USER_ID
HAVING COUNT(USER_ID) >= 3
ORDER BY USER_ID DESC

-- '경제' 카테고리에 속하는 도서들의
-- 도서 ID(BOOK_ID), 저자명(AUTHOR_NAME), 출판일(PUBLISHED_DATE) 리스트를 출력하는 SQL문을 작성해주세요.
-- 결과는 출판일을 기준으로 오름차순 정렬해주세요.
SELECT BOOK_ID, AUTHOR_NAME, DATE_FORMAT(PUBLISHED_DATE, '%Y-%m-%d') AS PUBLISHED_DATE
FROM BOOK AS B
JOIN AUTHOR AS A
ON B.AUTHOR_ID = A.AUTHOR_ID
WHERE CATEGORY = '경제'
ORDER BY PUBLISHED_DATE

-- PRODUCT 테이블과 OFFLINE_SALE 테이블에서 상품코드 별 매출액(판매가 * 판매량) 합계를 출력하는 SQL문을 작성해주세요.
-- 결과는 매출액을 기준으로 내림차순 정렬해주시고 매출액이 같다면 상품코드를 기준으로 오름차순 정렬해주세요.
SELECT PRODUCT_CODE, SUM(PRICE * SALES_AMOUNT) AS SALES
FROM PRODUCT AS T1
JOIN OFFLINE_SALE AS T2
ON T1.PRODUCT_ID = T2.PRODUCT_ID
GROUP BY PRODUCT_CODE
ORDER BY SALES DESC, PRODUCT_CODE
