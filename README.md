Submission Reminder App
A shell script-based application that helps track student submission status and identify students who need reminders for pending assignments.
Overview
This application consists of two main components:

Environment Setup Script (create_environment.sh) - Sets up the complete application directory structure
Copilot Script (copilot_shell_script.sh) - Allows dynamic assignment updates and application execution

Features

Automated Environment Setup: Creates organized directory structure with all necessary files
Student Submission Tracking: Monitors submission status for multiple assignments
Dynamic Assignment Updates: Change assignment names without manual file editing
Logging System: Tracks all reminder checks with timestamps
Extensible Data Format: Easy to add new student records

Quick Start
1. Initial Setup
First, make the setup script executable and run it:
bashchmod +x create_environment.sh
./create_environment.sh
When prompted, enter your name. This will create a directory named submission_reminder_{YourName}.
2. Test the Application
Navigate to the created directory and run the application:
bashcd submission_reminder_{YourName}
./startup.sh
3. Update Assignment (Optional)
To check submissions for a different assignment:
bash# Make sure you're in the parent directory (not inside the app directory)
chmod +x copilot_shell_script.sh
./copilot_shell_script.sh
