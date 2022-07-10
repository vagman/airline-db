DB_HOST = "localhost"
DB_NAME = "airline_db"
DB_USER = "postgres"
DB_PASSWORD = "1234"

import psycopg2
from psycopg2 import Error


def cursor(no_of_exercise):
    
    if(no_of_exercise == 'a' or no_of_exercise == 'A'):
        print("a")
        try:
            #for every time i want to return a connection (conn) object
            conn = psycopg2.connect(host = DB_HOST, dbname = DB_NAME, user = DB_USER, password = DB_PASSWORD)

            #DB API (to connect python)
            #Creating a 'cursor' object for actually working with queries
            cur = conn.cursor()


            sqlQueryA = '''SELECT * FROM airport'''

            cur.execute(sqlQueryA)
            results = cur.fetchall()
            for table in results:
                print(table)
        except:
            print("Something gets wrong")
        finally:
            conn.close()
            cur.close()
    elif(no_of_exercise == 'b' or no_of_exercise == 'B'):
        print("b")
        try:
            #for every time i want to return a connection (conn) object
            conn = psycopg2.connect(host = DB_HOST, dbname = DB_NAME, user = DB_USER, password = DB_PASSWORD)

            #DB API (to connect python)
            #Creating a 'cursor' object for actually working with queries
            cur = conn.cursor()


            sqlQueryA = '''SELECT * FROM airport'''

            cur.execute(sqlQueryA)
            results = cur.fetchall()
            for table in results:
                print(table)
        except:
            print("Something gets wrong")
        finally:
            conn.close()
            cur.close()
    elif(no_of_exercise == 'c' or no_of_exercise == 'C'):
        print("c")
        try:
            #for every time i want to return a connection (conn) object
            conn = psycopg2.connect(host = DB_HOST, dbname = DB_NAME, user = DB_USER, password = DB_PASSWORD)

            #DB API (to connect python)
            #Creating a 'cursor' object for actually working with queries
            cur = conn.cursor()


            sqlQueryA = '''SELECT * FROM airport'''

            cur.execute(sqlQueryA)
            results = cur.fetchall()
            for table in results:
                print(table)
        except:
            print("Something gets wrong")
        finally:
            conn.close()
            cur.close()
    elif(no_of_exercise == 'd' or no_of_exercise == 'D'):
        print("d")
        try:
            #for every time i want to return a connection (conn) object
            conn = psycopg2.connect(host = DB_HOST, dbname = DB_NAME, user = DB_USER, password = DB_PASSWORD)

            #DB API (to connect python)
            #Creating a 'cursor' object for actually working with queries
            cur = conn.cursor()


            sqlQueryA = '''SELECT * FROM airport'''

            cur.execute(sqlQueryA)
            results = cur.fetchall()
            for table in results:
                print(table)
        except:
            print("Something gets wrong")
        finally:
            conn.close()
            cur.close()
    elif(no_of_exercise == 'e' or no_of_exercise == 'E'):
        print("e")
        try:
            #for every time i want to return a connection (conn) object
            conn = psycopg2.connect(host = DB_HOST, dbname = DB_NAME, user = DB_USER, password = DB_PASSWORD)

            #DB API (to connect python)
            #Creating a 'cursor' object for actually working with queries
            cur = conn.cursor()


            sqlQueryA = '''SELECT * FROM airport'''

            cur.execute(sqlQueryA)
            results = cur.fetchall()
            for table in results:
                print(table)
        except:
            print("Something gets wrong")
        finally:
            conn.close()
            cur.close()
    elif(no_of_exercise == 'f' or no_of_exercise == 'F'):
        print("f")
        try:
            #for every time i want to return a connection (conn) object
            conn = psycopg2.connect(host = DB_HOST, dbname = DB_NAME, user = DB_USER, password = DB_PASSWORD)

            #DB API (to connect python)
            #Creating a 'cursor' object for actually working with queries
            cur = conn.cursor()


            sqlQueryA = '''SELECT * FROM airport'''

            cur.execute(sqlQueryA)
            results = cur.fetchall()
            for table in results:
                print(table)
        except:
            print("Something gets wrong")
        finally:
            conn.close()
            cur.close()
        
while True: 
    str = input("Grapse pio erwtima thes na ulopoihseis 'h pata 'q' gia quit: ")    
    cursor(str) 
    if(str == 'q'):
        break 


# sqlQueryB = '''SELECT * FROM airport'''
# curB = conn.cursor()
# curB.execute(sqlQueryB)
# print(curB.fetchall())





















# import psycopg2
# from psycopg2 import Error

# try:
#     # Connect to an existing database
#     connection = psycopg2.connect(user="postgres",
#                                   password="1234",
#                                   host="127.0.0.1",
#                                   port="5050",
#                                   database="airline_db")

#     # Create a cursor to perform database operations
#     cursor = connection.cursor()
#     # Print PostgreSQL details
#     print("PostgreSQL server information")
#     print(connection.get_dsn_parameters(), "\n")
#     # Executing a SQL query
#     cursor.execute("SELECT version();")
#     # Fetch result
#     record = cursor.fetchone()
#     print("You are connected to - ", record, "\n")

# except (Exception, Error) as error:
#     print("Error while connecting to PostgreSQL", error)
# finally:
#     if (connection):
#         cursor.close()
#         connection.close()
#         print("PostgreSQL connection is closed")