# Role Based Authentication system developed using 8086 Assembly Language

## Overview
The project aims to implement role-based authentication for a grading management system using 8086 assembly language. This system serves as the backbone for managing user authentication and access control, with roles defined for teachers and students. Through careful design and implementation, an attempt was made to ensure basic security access to sensitive information such as student grades while providing appropriate functionality to authorized users.

## Key Features
1. **Role-Based Authentication:** The system implements a role-based authentication mechanism where users are categorized into two roles: teachers and students. Each user must authenticate themselves with their respective credentials to access the system.
2. **Student Access:** Upon successful authentication, students gain access to their own grades. They can view only their grades securely without being able to access or modify grades of other students.
3. **Teacher Access:** Teachers have privileged access rights, allowing them to view and update grades for all students.
4. **Additional Features:** “Logout” >> “End Program” prompt after every session to maintain standard flow of the program.

## Other Implementation Details
1. **User Interface:** The default UI of “emu8086” is used here and the keyboard only interaction gives this project a classic touch.
2. **Error Handling:** Our project incorporates error handling mechanisms to manage invalid inputs, unauthorized access attempts, and other potential errors gracefully.

## Installation:
1. Clone this repository first using:  
```bash
git clone https://github.com/saminnimas/Role_Based_auth_8086.git
```
2. Install "emu8086" emulator to run the main.asm file in it.

## Login Credentials (when the program runs)
1. Open the main.asm source file.
2. The first 2 arrays (registered_users and password_arr) have the usernames and password.
![showing arrays](https://github.com/saminnimas/Role_Based_auth_8086/blob/main/indirect_indexed.png)
3. The algorithm works by "indirectly indexing" the first 5 arrays; so match the index number for username and password to input proper user credentials.
4. For example: for the username 'victor' password is 'vic', for user 'joy' password is 'enjoy'; hope you get the drift.
5. Enjoy :sunglasses: