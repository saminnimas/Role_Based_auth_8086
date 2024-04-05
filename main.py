"""
i) only a student can check his grade. DONE
ii) make another role called teacher who will be able to check or update their grades. DONE
iii) check if the user is a student or a teacher. DONE
iv) allow marks entry only if user is a teacher.
"""
registered_users = ['lara', 'clerk', 'joy', 'jim', 'sumbul', 'tim', 'bruce', 'victor']  # put only usernames here
passwords_arr = ["raider", "lane", "enjoy", "pam", "harem", "code", "Batcave28", "vic"]  # map user passwords with registered_users
user_role = ['s', 's', 's', 's', 's', 's', 't', 't']
id_s = [1, 2, 3, 4, 5, 6]
marks = [85, 80, 95, 75, 39, 66]

while True:
    username = input("Enter Username: ")
    password = input('Enter Password: ')


    def len_counter(user) -> int:
        length = 0
        for _ in user:
            length += 1

        return length
        # store the returned statements in a variable


    username_length = len_counter(username)


    def valid_username(user: str, user_length, registered_arr: list) -> int:
        elem_num = 0
        for i in range(len(registered_arr)):
            count = 1
            for j in range(user_length - 1):
                if user_length != len_counter(registered_arr[i]):
                    break
                elif user[j] != registered_arr[i][j]:
                    break
                elif user_length < len_counter(registered_arr[i]):
                    break
                elif user_length > len_counter(registered_arr[i]):
                    break
                else:
                    count += 1
            # print(count)
            if count == user_length:
                elem_num = i + 1
                return elem_num

        return elem_num
        # store the returned statements in a variable


    def authenticate(validated_username, loaded_pass, user_pass):
        if validated_username <= 0:
            return False
        elif loaded_pass == 0:
            return False
        else:
            if len_counter(user_pass) < len_counter(loaded_pass):
                return False
            elif len_counter(user_pass) > len_counter(loaded_pass):
                return False
            else:
                for i in range(len(loaded_pass)):
                    if user_pass[i] != loaded_pass[i]:
                        return False
                return True
            # store the returned statements in a variable


    def load_pass(user_occurrence, passwrd_arr) -> str or int:
        if user_occurrence > 0:
            return passwrd_arr[user_occurrence - 1]
        else:
            return 0
        # store the returned statements in a variable


    # the valid_username had to be written in a redundant form; to replicate the structure of procedural programming of 8086
    # valid_user="Invalid username" if not valid_username(username, username_length, '123', registered_users) else "WElCOME"

    valid_user = valid_username(username, username_length, registered_users)
    # print(valid_user)

    loaded_password = load_pass(valid_user, passwords_arr)
    # print(loaded_password)
    print(authenticated := authenticate(valid_user, loaded_password, password))
    print(user_role[valid_user - 1])

    user_type = user_role[valid_user - 1]
    if user_type == 't':
        print("Teacher's Profile")
        print(f"Name: {registered_users[valid_user - 1]}")
        view_grades = input("View Student Grades? (y/n) ")
        if view_grades == 'y':
            print("ID           Name          Marks")
            print('-----        -----         -----')
            for i in range(len(id_s)):
                if len(registered_users[i]) == 3:
                    print(f"{id_s[i]}            {registered_users[i]}            {marks[i]}")
                else:
                    print(str(id_s[i]) + (12 * ' ') + str(registered_users[i]) + (12 - (len(registered_users[i]) - 3)) * ' ' + str(marks[i]))
                    # this print statement above is just for demo purpose. Ignore in main project
        update_grade = input("Update Grades? (y/n) ")
        if update_grade == "y":
            select_id = int(input("Enter ID: "))
            if 0 < select_id < len(id_s) + 1:
                print(f"ID: {select_id}, Name: {registered_users[select_id - 1]}, Marks: {marks[select_id - 1]}")
                update = int(input("Input Updated Marks: "))
                marks[select_id - 1] = update
                print("updated Result")
                print(f"ID: {select_id}, Name: {registered_users[select_id - 1]}, Marks: {marks[select_id - 1]}")
            else:
                print("Invalid ID")
    else:
        print("Student's Profile")
        print("ID           Name          Marks")
        if len(registered_users[valid_user - 1]) == 3:
            print(f"{id_s[valid_user - 1]}            {registered_users[valid_user - 1]}            {marks[valid_user - 1]}")
        else:
            print(str(id_s[valid_user - 1]) + (12 * ' ') + str(registered_users[valid_user - 1]) + (12 - (len(registered_users[valid_user - 1]) - 3)) * ' ' + str(
                marks[valid_user - 1]))

    end_p = input("Logout? (y/n) ")
    if end_p == 'y':
        break
    # places where functions were invoked; in assembly make sure to store the appropriate values within a variable to
    # replicate the function calls implemented in this program. (read all the comments within each function)


