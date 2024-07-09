# User Manual for Microcontroller Password Management System

## Introduction
This user manual provides detailed instructions for operating a microcontroller-based password management system. The system includes a time clock, keypad for password entry, 7-segment displays for visual feedback, and a logic probe indicator.

## Components
- **Microcontroller** (Atmega 32)
- **Keypad** (numeric keypad with additional '*' and '#' buttons)
- **7-Segment Displays** (for visual feedback)
- **Logic Probe** (for indicating valid password entry)
- **Time Clock** (to display elapsed time)

## Operating Instructions

### 1. System Start
- Upon powering up the system, the time clock will start and display the elapsed time since the program started.
- The system is now ready to receive password input through the keypad.

### 2. Entering a Password
- **Valid Password Entry:**
  1. Use the keypad to enter a password.
  2. If the entered password matches one of the stored passwords, the program will indicate a successful entry by showing “1” on the logic probe and saves the password and time elapsed of it to show in log later.
- **Invalid Password Entry:**
  1. Use the keypad to enter a password.
  2. If the entered password does not match any stored password, the program will display “dd0000” on the 7-segment displays, indicating an invalid password.

### 3. Adding a New Password
- To add a new password, press the “*” button on the keypad.
- The 7-segment displays will show “AAAAAA”, indicating the system is in password addition mode.
- Enter the new password using the keypad.
- Once the new password is added, future entries of this password will show “1” on the logic probe, indicating a valid password.

### 4. Viewing the Log
- To view the log, press the “#” button on the keypad.
- The 7-segment displays will show the log in the following sequence:
  1. **"FFFFFF"**: Indicates that the program is about to display a stored password.
  2. After 2 seconds, the display will show the stored password followed by "AA". For example, if the password is "1111", the display will show "1111AA".
  3. After 3 more seconds, the display will show the elapsed time when the specific password was entered.
