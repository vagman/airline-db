DB_HOST = "localhost"
DB_NAME = "airline"
DB_USER = "postgres"
DB_PASSWORD = "1234"

import psycopg2


class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    RED = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

def cursor(no_of_exercise):
    
    # Query a
    if(no_of_exercise == 'a' or no_of_exercise == 'A' or no_of_exercise == '1'):
        print("-----------------------\n+++++" + bcolors.OKBLUE + "Query (a)" + bcolors.ENDC + "+++++\n-----------------------")
        try:
            #for every time i want to return a connection (conn) object
            conn = psycopg2.connect(host = DB_HOST, dbname = DB_NAME, user = DB_USER, password = DB_PASSWORD)

            #DB API (to connect python)
            #Creating a 'cursor' object for actually working with queries
            cur = conn.cursor()

            sqlQueryA = '''SELECT P.passenger_id, P.passenger_name, B.book_date
                    FROM flight AS F 
                    JOIN ticket AS T ON F.flight_id = T.flight_id
                    JOIN booking AS B ON T.book_ref = B.book_ref
                    JOIN passenger AS P ON T.passenger_id = P.passenger_id
                    JOIN boarding_pass AS BP ON T.ticket_no = BP.ticket_no
                    WHERE F.flight_id = 33 
                        AND BP.seat_no = '1A' 
                        AND B.book_date = CURRENT_DATE - 1;'''

            cur.execute(sqlQueryA)
            results = cur.fetchall()
            print(bcolors.BOLD + "passenger_id | passenger_name | book_date" + bcolors.ENDC)
            for table in results:
                print(table)
            print("\n")
        except:
            print("Something gets wrong")
        finally:
            conn.close()
            cur.close()
            
    # Query B
    elif(no_of_exercise == 'b' or no_of_exercise == 'B') or no_of_exercise == '2':
        print("-----------------------\n+++++" + bcolors.OKBLUE + "Query (b)" + bcolors.ENDC + "+++++\n-----------------------")
        try:
            #for every time i want to return a connection (conn) object
            conn = psycopg2.connect(host = DB_HOST, dbname = DB_NAME, user = DB_USER, password = DB_PASSWORD)

            #DB API (to connect python)
            #Creating a 'cursor' object for actually working with queries
            cur = conn.cursor()

            sqlQueryB = '''SELECT M.capacity AS total_seats, COUNT(*) AS reserved_seats, M.capacity - COUNT(*) AS blank_seats
                            FROM boarding_pass AS B
                            JOIN flight AS F ON F.flight_id = B.flight_id
                            JOIN aircraft AS A ON A.aircraft_code = F.aircraft_code
                            JOIN model AS M ON M.aircraft_model = A.aircraft_model
                            WHERE B.flight_id = 33
                            GROUP BY M.capacity;'''

            cur.execute(sqlQueryB)
            results = cur.fetchall()
            print(bcolors.BOLD + "total_seats | reserved_seats | blank_seats" + bcolors.ENDC)
            for table in results:
                print(table)
            print("\n")
        except:
            print("Something gets wrong")
        finally:
            conn.close()
            cur.close()
            
    # Query c
    elif(no_of_exercise == 'c' or no_of_exercise == 'C' or no_of_exercise == '3'):
        print("-----------------------\n+++++" + bcolors.OKBLUE + "Query (c)" + bcolors.ENDC + "+++++\n-----------------------")
        try:
            #for every time i want to return a connection (conn) object
            conn = psycopg2.connect(host = DB_HOST, dbname = DB_NAME, user = DB_USER, password = DB_PASSWORD)

            #DB API (to connect python)
            #Creating a 'cursor' object for actually working with queries
            cur = conn.cursor()

            sqlQueryC = '''SELECT F.flight_id, (SELECT (EXTRACT(epoch FROM(SELECT (A.actual_arrival_time - A.actual_departure_time)))/3600)::float) AS delay_in_hours, F.departure_date 
                        FROM flight AS F
                        JOIN actual_status AS A ON A.flight_id = F.flight_id
                        WHERE EXTRACT(YEAR FROM F.departure_date) = 2022
                            AND (SELECT (EXTRACT(epoch FROM(SELECT (A.actual_arrival_time - A.actual_departure_time)))/3600)::float) IS NOT NULL
                        ORDER BY delay_in_hours DESC
                        LIMIT 5;
                        '''

            cur.execute(sqlQueryC)
            results = cur.fetchall()
            print(bcolors.BOLD + "flight_id | delay_in_hours | departure_date" + bcolors.ENDC)
            for table in results:
                print(table)
            print("\n")
        except:
            print("Something gets wrong")
        finally:
            conn.close()
            cur.close()
            
    # Query d       
    elif(no_of_exercise == 'd' or no_of_exercise == 'D' or no_of_exercise == '4'):
        print("-----------------------\n+++++" + bcolors.OKBLUE + "Query (d)" + bcolors.ENDC + "+++++\n-----------------------")
        try: 
            #for every time i want to return a connection (conn) object
            conn = psycopg2.connect(host = DB_HOST, dbname = DB_NAME, user = DB_USER, password = DB_PASSWORD)

            #DB API (to connect python)
            #Creating a 'cursor' object for actually working with queries
            cur = conn.cursor()

            sqlQueryD = '''SELECT P.passenger_id, P.passenger_name, sum(F.flight_range) AS total_km_flown
                            FROM flight AS F
                            JOIN ticket AS T ON T.flight_id = F.flight_id
                            JOIN passenger AS P ON P.passenger_id = T.passenger_id
                            WHERE EXTRACT(YEAR FROM F.departure_date) = 2022
                            GROUP BY P.passenger_id
                            ORDER BY total_km_flown DESC
                            LIMIT 5;'''

            cur.execute(sqlQueryD)
            results = cur.fetchall()
            print(bcolors.BOLD + "passenger_id | passenger_name | total_km_flown" + bcolors.ENDC)
            for table in results:
                print(table)
            print("\n")
        except:
            print("Something gets wrong")
        finally:
            conn.close()
            cur.close()
            
    # Query e
    elif(no_of_exercise == 'e' or no_of_exercise == 'E' or no_of_exercise == '5'):
        print("-----------------------\n+++++" + bcolors.OKBLUE + "Query (e)" + bcolors.ENDC + "+++++\n-----------------------")
        try:
            #for every time i want to return a connection (conn) object
            conn = psycopg2.connect(host = DB_HOST, dbname = DB_NAME, user = DB_USER, password = DB_PASSWORD)

            #DB API (to connect python)
            #Creating a 'cursor' object for actually working with queries
            cur = conn.cursor()

            sqlQueryE = '''SELECT A.city, COUNT(*) AS appears
                            FROM flight AS F
                            JOIN airport AS A ON A.airport_code = F.arrival_airport
                            WHERE EXTRACT(YEAR FROM F.departure_date) = 2022
                            GROUP BY A.city
                            ORDER BY appears DESC
                            LIMIT 5;'''

            cur.execute(sqlQueryE)
            results = cur.fetchall()
            print(bcolors.BOLD + "city | no_of_appears" + bcolors.ENDC)
            for table in results:
                print(table)
            print("\n")
        except:
            print("Something gets wrong")
        finally:
            conn.close()
            cur.close()
            
    # Query f
    elif(no_of_exercise == 'f' or no_of_exercise == 'F' or no_of_exercise == '6'):
        print("-----------------------\n+++++" + bcolors.OKBLUE + "Query (f)" + bcolors.ENDC + "+++++\n-----------------------")
        try:
            #for every time i want to return a connection (conn) object
            conn = psycopg2.connect(host = DB_HOST, dbname = DB_NAME, user = DB_USER, password = DB_PASSWORD)

            #DB API (to connect python)
            #Creating a 'cursor' object for actually working with queries
            cur = conn.cursor()


            sqlQueryF = '''SELECT T.passenger_id, P.passenger_name, 
                            COUNT(T.passenger_id) AS passengers_total_flights, 
                            ROUND(CAST(AVG(B.boarding_no) AS numeric), 1) AS average_boarding_que
                        FROM ticket AS T 
                        JOIN boarding_pass AS B ON B.ticket_no = T.ticket_no
                        JOIN flight AS F ON F.flight_ID = T.flight_id
                        JOIN passenger AS P ON T.passenger_id = P.passenger_id
                        GROUP BY T.passenger_id, P.passenger_name
                        HAVING COUNT(T.passenger_id) > 1
                        ORDER BY average_boarding_que ASC;'''

            cur.execute(sqlQueryF)
            results = cur.fetchall()
            print(bcolors.BOLD + "passenger_id | passenger_name | passengers_total_flights || average_boarding_que" + bcolors.ENDC)
            for table in results:
                print(table)
            print("\n")
        except:
            print("Something gets wrong")
        finally:
            conn.close()
            cur.close()
    else:
        if(no_of_exercise == 'q'):
            return
        else:
            print(bcolors.RED + "Give a right Number of an exercise (for ex. type 'a' or '1' for the 1st query)!" + bcolors.ENDC)
        
while True: 
    try:
        str = input("Give the Number of the exercise you want to show (or type 'q' to quit):\n ")    
        cursor(str) 
        if(str == 'q'):
            break 
    except:
        print(bcolors.RED + "something wrong, if you want to quit type 'q'" + bcolors.ENDC)
