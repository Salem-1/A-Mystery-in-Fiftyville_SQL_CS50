select * from crime_scene_reports limit 3;
select * from crime_scene_reports where street like "%Chamberlin%" ;
select * from crime_scene_reports where street like "%Chamberlin%" AND description like "%CS50%" ;
SELECT * FROM interviews where transcript LIKE "%courthouse%";
select * from airports where city like "%fiftyville%";




-- Keep a log of any SQL queries you execute as you solve the mystery.
--10:15 am (the crime time)
--10:15 am + 10 a car drove form the parking lot(extract all liscences plates in this time)
> SELECT * FROM courthouse_security_logs  WHERE year = "2020" AND month = "7" AND day ="28" AND activity = "exit" AND hour > "9" ORDER BY hour DESC;
SELECT * FROM courthouse_security_logs  WHERE year = "2020" AND month = "7" AND day ="28" AND activity = "exit" AND hour= "10" ORDER BY hour DESC;
-- 3:00 pm he was taking on the phone (extract all phone calls in that time frame) Julie
SELECT * FROM phone_calls WHERE year = "2020" AND MONTH = "7" AND DAY = "28" AND caller LIKE ("%Danielle%" OR "%Russell%") AND reciever LIKE ("%Danielle%" OR "%Russell%");
-- extract all transaction from the crime scene location before 10:15 am
--the thief is going to travel tommorow with a his friend
-- talk with a friend less than a minute
-- said purchase tickets for both of them Raymond
--extract all the outbound flights from fiftyville
SELECT * from flights WHERE year = "2020" AND month = "7" AND day = "30" AND origin_airport_id = "8";
----------------------
--people who exited the parking that day
SELECT * FROM people WHERE license_plate in (SELECT license_plate  FROM courthouse_security_logs  WHERE year = "2020" AND month = "7"  AND day ="28" AND activity = "exit" AND hour= "10" ORDER BY hour DESC);
------
--- Getting people how travelled next day and exited the parking that hour

SELECT passport_number FROM passengers WHERE flight_id in(SELECT id from flights WHERE year = "2020" AND month = "7" AND day = "30" AND origin_airport_id = "8");
--Getting the two suspect names
SELECT name FROM people WHERE passport_number in (SELECT passport_number FROM passengers WHERE flight_id in(SELECT id from flights WHERE year = "2020" AND month = "7" AND day = "30" AND origin_airport_id = "8") AND passport_number in (SELECT passport_number FROM people WHERE license_plate in (SELECT license_plate  FROM courthouse_security_logs  WHERE year = "2020" AND month = "7"  AND day ="28" AND activity = "exit" AND hour= "10" ORDER BY hour DESC)));

---
--Getting the flight destination
WHERE passport_(SELECT passport_number FROM passengers WHERE flight_id in(SELECT id from flights WHERE year = "2020" AND month = "7" AND day = "30" AND origin_airport_id = "8") AND passport_number in (SELECT passport_number FROM people WHERE license_plate in (SELECT license_plate  FROM courthouse_security_logs  WHERE year = "2020" AND month = "7"  AND day ="28" AND activity = "exit" AND hour= "10" ORDER BY hour DESC)));

----
suspects flight id's are 11 for danielle (389) 555-5198
and 54 for russell (770) 555-1861
------("%(389) 555-5198%" OR "%(770) 555-1861%")
SELECT * from airports where id = '12';

Danielle 12 | DEL | Indira Gandhi International Airport | Delhi

----
Russell 5 | DFS | Dallas/Fort Worth International Airport | Dallas



---
--phone calls
SELECT * FROM phone_calls WHERE year = "2020" AND month = "7" AND day = "28";


SELECT * FROM phone_calls WHERE year = "2020" AND month = "7" AND day = "28" AND caller = ("%(389) 555-5198%" OR "%(770) 555-1861%"); 


id | name | phone_number | passport_number | license_plate
514354 | Russell | (770) 555-1861 | 3592750733 | 322W7JE


--Tracking Russel phone calls
SELECT * FROM phone_calls WHERE year = "2020" AND day = "28" AND month = "7" AND (caller = "(770) 555-1861" OR receiver = "(770) 555-1861");
--Getting the filthy partner details
SELECT * FROM people WHERE phone_number = "(725) 555-3243";
-----------------------------------------------------------------------------
--================Hitting a wall , starting all over again==============--- 
----
SELECT * FROM crime_scene_reports WHERE description LIKE "%CS50%";
SELECT * FROM interviews WHERE transcript LIKE "%courthouse%";
-- this a huge mistke , filter by date idiot
SELECT * FROM interviews WHERE year = "2020" and month  = "7" AND transcript LIKE "%courthouse%";
--- getting the cars plate
SELECT * FROM courthouse_security_logs WHERE year = "2020" and month  = "7" AND day = "28" AND hour = "10" AND activity = "exit";

-------List of intial suspects who left the courthouse right after the crime
5P2BI95
94KL13X
6P58WS2
4328GD8
G412CB7
L93JTIZ
322W7JE
0NTHK55
1106N58
-----Getting thier personal data 
SELECT id FROM people WHERE license_plate in (SELECT license_plate FROM courthouse_security_logs WHERE year = "2020" and month  = "7" AND day = "28" AND hour = "10" AND activity = "exit");
-------
221103 | Patrick | (725) 555-4692 | 2963008352 | 5P2BI95
243696 | Amber | (301) 555-4174 | 7526138472 | 6P58WS2
396669 | Elizabeth | (829) 555-5269 | 7049073643 | L93JTIZ
398010 | Roger | (130) 555-0289 | 1695452385 | G412CB7
449774 | Madison | (286) 555-6063 | 1988161715 | 1106N58
467400 | Danielle | (389) 555-5198 | 8496433585 | 4328GD8
514354 | Russell | (770) 555-1861 | 3592750733 | 322W7JE
560886 | Evelyn | (499) 555-9472 | 8294398571 | 0NTHK55
686048 | Ernest | (367) 555-5533 | 5773159633 | 94KL13X


SELECT * 
FROM atm_transactions a 
JOIN bank_accounts b 
ON a.account_number = b.account_number 
JOIN people p 
ON p.id = b.person_id 
WHERE a.year = "2020" AND a.month = "7" AND a.day ="28" AND a.atm_location LIKE "%Fifer street%" 
AND b.person_id in (SELECT id FROM people WHERE license_plate in (SELECT license_plate FROM courthouse_security_logs WHERE year = "2020" and month  = "7" AND day = "28" AND hour = "10" AND activity = "exit"));

------ Well well , now we. have a short list Aha.
(367) 555-5533 | Ernest
(770) 555-1861 | Russell
(829) 555-5269 | Elizabeth
(389) 555-5198 | Danielle
(286) 555-6063 | Madison

---- onne more layer of abstraction the phone call to the filthy thief and his escort
id | caller | receiver | year | month | day | duration

SELECT * FROM  phone_calls c
JOIN people p 
ON p.phone_number = c.caller
WHERE c.duration < 70 AND c.year = "2020" and c.month  = "7" AND c.day = "28" AND 
(c.caller in (SELECT p.phone_number 
FROM atm_transactions a 
JOIN bank_accounts b 
ON a.account_number = b.account_number 
JOIN people p 
ON p.id = b.person_id 
WHERE a.year = "2020" AND a.month = "7" AND a.day ="28" AND a.atm_location LIKE "%Fifer street%" 
AND b.person_id in (SELECT id FROM people WHERE license_plate in (SELECT license_plate FROM courthouse_security_logs WHERE year = "2020" and month  = "7" AND day = "28" AND hour = "10" AND activity = "exit"))) 
or c.receiver in (SELECT p.phone_number 
FROM atm_transactions a 
JOIN bank_accounts b 
ON a.account_number = b.account_number 
JOIN people p 
ON p.id = b.person_id 
WHERE a.year = "2020" AND a.month = "7" AND a.day ="28" AND a.atm_location LIKE "%Fifer street%" 
AND b.person_id in (SELECT id FROM people WHERE license_plate in (SELECT license_plate FROM courthouse_security_logs WHERE year = "2020" and month  = "7" AND day = "28" AND hour = "10" AND activity = "exit")))) ;


------
--callers
Ernest---->Berthold
Kathryn----Danielle
Madison---->james
Russell---->philip
--passport numbers
5773159633
6121106406
1988161715
3592750733
--------------
--Reciever
8496433585
2438825627
3391710505
Berthold
Danielle
James
Philip

8496433585

---------mmmmm it's getting better
        caller | receiver | receiver_name
        (367) 555-5533 | (375) 555-8161 | Berthold
        (609) 555-5876 | (389) 555-5198 | Danielle
        (286) 555-6063 | (676) 555-6554 | James
        (770) 555-1861 | (725) 555-3243 | Philip
        --lovely pairs
Ernest | (367) 555-5533 | (375) 555-8161| Berthold --- such a lucky innocent guy with no pasport 

-- mmm it seems we have a shortlist here
Kathryn | (609) 555-5876 | (389) 555-5198| Danielle
Madison | (286) 555-6063 | (676) 555-6554| James
Russell | (770) 555-1861 | (725) 555-3243| Philip


449774 | Madison | (286) 555-6063 | 1988161715 | 1106N58
467400 | Danielle | (389) 555-5198 | 8496433585 | 4328GD8
514354 | Russell | (770) 555-1861 | 3592750733 | 322W7JE

----- getting the lovely flight and pasanger details

SELECT *
FROM flights f
JOIN airports a 
ON a.id = f.destination_airport_id 
JOIN passengers p 
ON p.flight_id = f.id
JOIN people h
ON h.passport_number = p.passport_number
WHERE f.year = "2020" and f.month  = "7" AND f.day = "29" AND f.origin_airport_id = "8" AND (p.passport_number IN 
(SELECT p.passport_number FROM  phone_calls c
JOIN people p 
ON p.phone_number = c.caller
WHERE c.duration < 70 AND c.year = "2020" and c.month  = "7" AND c.day = "28" AND 
(c.caller in (SELECT p.phone_number 
FROM atm_transactions a 
JOIN bank_accounts b 
ON a.account_number = b.account_number 
JOIN people p 
ON p.id = b.person_id 
WHERE a.year = "2020" AND a.month = "7" AND a.day ="28" AND a.atm_location LIKE "%Fifer street%" 
AND b.person_id in (SELECT id FROM people WHERE license_plate in (SELECT license_plate FROM courthouse_security_logs WHERE year = "2020" and month  = "7" AND day = "28" AND hour = "10" AND activity = "exit"))) 
or c.receiver in (SELECT p.phone_number 
FROM atm_transactions a 
JOIN bank_accounts b 
ON a.account_number = b.account_number 
JOIN people p 
ON p.id = b.person_id 
WHERE a.year = "2020" AND a.month = "7" AND a.day ="28" AND a.atm_location LIKE "%Fifer street%" 
AND b.person_id in (SELECT id FROM people WHERE license_plate in (SELECT license_plate FROM courthouse_security_logs WHERE year = "2020" and month  = "7" AND day = "28" AND hour = "10" AND activity = "exit")))) )
or p.passport_number in (SELECT p.passport_number FROM  phone_calls c
JOIN people p 
ON p.phone_number = c.receiver
WHERE c.duration < 70 AND c.year = "2020" and c.month  = "7" AND c.day = "28" AND 
(c.caller in (SELECT p.phone_number 
FROM atm_transactions a 
JOIN bank_accounts b 
ON a.account_number = b.account_number 
JOIN people p 
ON p.id = b.person_id
WHERE a.year = "2020" AND a.month = "7" AND a.day ="28" AND a.atm_location LIKE "%Fifer street%" 
AND b.person_id in (SELECT id FROM people WHERE license_plate in (SELECT license_plate FROM courthouse_security_logs WHERE year = "2020" and month  = "7" AND day = "28" AND hour = "10" AND activity = "exit"))) 
or c.receiver in (SELECT p.phone_number 
FROM atm_transactions a 
JOIN bank_accounts b 
ON a.account_number = b.account_number 
JOIN people p 
ON p.id = b.person_id 
WHERE a.year = "2020" AND a.month = "7" AND a.day ="28" AND a.atm_location LIKE "%Fifer street%" 
AND b.person_id in (SELECT id FROM people WHERE license_plate in (SELECT license_plate FROM courthouse_security_logs WHERE year = "2020" and month  = "7" AND day = "28" AND hour = "10" AND activity = "exit")))) ));
-----
--caller passport numbers 
3592750733
1988161715

-----
--getting receiver passport numnbers

SELECT * 
FROM flights f
JOIN airports a 
ON a.id = f.destination_airport_id 
JOIN passengers p 
ON p.flight_id = f.id
WHERE year = "2020" and month  = "7" AND day = "29" AND f.origin_airport_id = "8" AND p.passport_number IN 
(SELECT p.passport_number FROM  phone_calls c
JOIN people p 
ON p.phone_number = c.receiver
WHERE c.duration < 70 AND c.year = "2020" and c.month  = "7" AND c.day = "28" AND 
(c.caller in (SELECT p.phone_number 
FROM atm_transactions a 
JOIN bank_accounts b 
ON a.account_number = b.account_number 
JOIN people p 
ON p.id = b.person_id 
WHERE a.year = "2020" AND a.month = "7" AND a.day ="28" AND a.atm_location LIKE "%Fifer street%" 
AND b.person_id in (SELECT id FROM people WHERE license_plate in (SELECT license_plate FROM courthouse_security_logs WHERE year = "2020" and month  = "7" AND day = "28" AND hour = "10" AND activity = "exit"))) 
or c.receiver in (SELECT p.phone_number 
FROM atm_transactions a 
JOIN bank_accounts b 
ON a.account_number = b.account_number 
JOIN people p 
ON p.id = b.person_id 
WHERE a.year = "2020" AND a.month = "7" AND a.day ="28" AND a.atm_location LIKE "%Fifer street%" 
AND b.person_id in (SELECT id FROM people WHERE license_plate in (SELECT license_plate FROM courthouse_security_logs WHERE year = "2020" and month  = "7" AND day = "28" AND hour = "10" AND activity = "exit")))) )
;

---congratulations 
-- receiver passport number 
8496433585

--- Those are the criminals
Kathryn | (609) 555-5876 | (389) 555-5198| Danielle.  London seat 7B




SELECT * 
FROM atm_transactions a 
JOIN bank_accounts b 
ON a.account_number = b.account_number 
JOIN people p 
ON p.id = b.person_id 
WHERE a.year = "2020" AND a.month = "7" AND a.day ="28" AND a.atm_location LIKE "%Fifer street%" 
AND b.person_id in (SELECT id FROM people WHERE license_plate in (SELECT license_plate FROM courthouse_security_logs WHERE year = "2020" and month  = "7" AND day = "28" AND hour = "10" AND activity = "exit"));



SELECT p.phone_number,p.name 
FROM atm_transactions a 
JOIN bank_accounts b 
ON a.account_number = b.account_number 
JOIN people p 
ON p.id = b.person_id 
WHERE a.year = "2020" AND a.month = "7" AND a.day ="28" AND (p.phone_number = "(609) 555-5876" or 
p.phone_number = "(676) 555-6554" or p.phone_number = "(725) 555-3243");


Kathryn | (609) 555-5876 | (389) 555-5198| Danielle
Madison | (286) 555-6063 | (676) 555-6554| James
Russell | (770) 555-1861 | (725) 555-3243| Philip


SELECT  p.name
FROM atm_transactions a
JOIN bank_accounts b
ON a.account_number = b.account_number
JOIN people p 
ON p.id  = b.person_id
WHERE a.year = "2020" AND a.month = "7" 
AND a.day = "28" 
ORDER By p.name;