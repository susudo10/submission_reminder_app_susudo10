#!/bin/bash

# Submission Reminder App Environment Setup Script
# This script creates the directory structure and files for the submission reminder application

echo "=== Submission Reminder App Environment Setup ==="
echo

# Prompt user for their name
read -p "Enter your name: " user_name

# Validate input
if [ -z "$user_name" ]; then
    echo "Error: Name cannot be empty!"
    exit 1
fi

# Create main directory
main_dir="submission_reminder_${user_name}"
echo "Creating directory: $main_dir"

if [ -d "$main_dir" ]; then
    echo "Warning: Directory $main_dir already exists. Removing it..."
    rm -rf "$main_dir"
fi

mkdir "$main_dir"
cd "$main_dir"

# Create subdirectories
echo "Creating subdirectories..."
mkdir -p config
mkdir -p app
mkdir -p modules
mkdir -p assets

echo "Directory structure created successfully!"

# Create config.env file
echo "Creating config/config.env..."
cat > config/config.env << 'EOF'
APP_NAME="Submission Reminder App"
ASSIGNMENT="Data Structures Assignment"
REMINDER_DAYS=3
LOG_FILE="logs/reminder.log"
DATA_FILE="data/submissions.txt"
EOF

# Create functions.sh file
echo "Creating modules/functions.sh..."
cat > modules/functions.sh << 'EOF'
#!/bin/bash

function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF
# Create reminder.sh file
echo "Creating scripts/reminder.sh..."
cat > app/reminder.sh << 'EOF'
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file

EOF

# Create submissions.txt file with sample data
echo "Creating data/submissions.txt..."
cat > assets/submissions.txt << 'EOF'
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted

EOF

# Create startup.sh file
echo "Creating startup.sh..."
cat > startup.sh << 'EOF'
#!/bin/bash

# Startup script for Submission Reminder App
# This script initializes and runs the reminder application

echo "=== Starting Submission Reminder App ==="
echo

# Check if we're in the right directory
if [ ! -d "config" ] || [ ! -d "app" ] || [ ! -d "assets" ]; then
    echo "Error: Important directories are missing, please confirm your root directory"
    exit 1
fi


# Make sure all shell scripts are executable
echo "Setting executable permissions for shell scripts..."
find . -name "*.sh" -type f -exec chmod +x {} \;

# Run the reminder script
echo "Running reminder application..."
echo
./app/reminder.sh

echo
echo "=== Application execution completed ==="
EOF

# Set executable permissions for all .sh files
echo "Setting executable permissions for all shell scripts..."
find . -name "*.sh" -type f -exec chmod +x {} \;
echo "Environment setup completed successfully!"
