"""
i) only a student can check his grade
ii) make another role called teacher who will be able to check or update their grades.
iii) check if the user is a student or a teacher
iv) allow marks entry only if user is a teacher.
"""
registered_users = ['ara', 'bruce']  # put only usernames here
passwords_arr = ["Batcave28"]  # map user passwords with registered_users

username = input("Enter Username: ")
# password = input('Enter Password: ')


def len_username(user) -> int:
    length = 0
    for _ in user:
        length += 1

    return length


username_length = len_username(username)


def valid_username(user: str, user_length, passwrd: str, registered_arr: list) -> bool:
    for i in range(len(registered_arr)):
        for j in range(user_length - 1):
            if user_length != len_username(registered_arr[i]):
                break
            elif user[j] != registered_arr[i][j]:
                break
            elif user_length < len_username(registered_arr[i]):
                break
            elif user_length > len_username(registered_arr[i]):
                break
            else:
                return True
    return False

# the valid_username had to be written in a redundant form; to replicate the structure of procedural programming of 8086


print("Invalid username" if not valid_username(username, username_length, '123', registered_users) else "WElCOME")

