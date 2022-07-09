import datetime
import colorama
from colorama import Fore, Style


extKey = strTime = ''


while True:
    
    #user gives the time he wants
    strTime = str(input("Give time in HH:MM (or press q to quit): "))
    try:
        if strTime == 'q':
            print("Goodbye!")
            break;
        else:
            #converts user's time to time
            tmTime = datetime.datetime.strptime(strTime, "%H:%M")




            #user gives the hours he wants to add to his time
            hours_to_add = float(input("Give the hours you want to add:  "))


            newTime = tmTime + datetime.timedelta(hours=hours_to_add)
            new_time = newTime.strftime('%H:%M')

            print("\nYour time is:") 
            print(Fore.RED + new_time)
            print(Style.RESET_ALL + "---------------------\n")
    except:
        print(Fore.GREEN + "Type a valid time format (HH:MM) !!!")
        print(Style.RESET_ALL)
   
