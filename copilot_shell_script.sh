#!/bin/bash

# Copilot Shell Script for Submission Reminder App
# This script allows users to change the assignment name in the configuration
# and rerun the reminder check for the new assignment

echo "=== Submission Reminder App - Assignment Updater ==="
echo

# Function to find the submission reminder directory
find_app_directory() {
    # Look for directories matching the pattern submission_reminder_*
    local app_dirs=($(find . -maxdepth 1 -type d -name "submission_reminder_*" 2>/dev/null))
    
    if [ ${#app_dirs[@]} -eq 0 ]; then
        echo "Error: No submission reminder app directory found!"
        echo "Please make sure you have created the environment using create_environment.sh first."
        exit 1
    elif [ ${#app_dirs[@]} -eq 1 ]; then
        APP_DIR="${app_dirs[0]}"
    else
        echo "Multiple submission reminder directories found:"
        for i in "${!app_dirs[@]}"; do
            echo "$((i+1)). ${app_dirs[i]}"
        done
        echo
        read -p "Select directory (1-${#app_dirs[@]}): " choice
        
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le ${#app_dirs[@]} ]; then
            APP_DIR="${app_dirs[$((choice-1))]}"
        else
            echo "Invalid selection. Exiting."
            exit 1
        fi
    fi
    
    echo "Using directory: $APP_DIR"
    echo
}

# Function to validate app directory structure
validate_directory() {
    if [ ! -d "$APP_DIR/config" ] || [ ! -f "$APP_DIR/config/config.env" ]; then
        echo "Error: Invalid app directory structure!"
        echo "Missing config/config.env file."
        exit 1
    fi
    
    if [ ! -f "$APP_DIR/startup.sh" ]; then
        echo "Error: startup.sh not found in $APP_DIR"
        exit 1
    fi
}

# Function to display current assignment
show_current_assignment() {
    local current_assignment=$(grep "^ASSIGNMENT=" "$APP_DIR/config/config.env" | cut -d'"' -f2)
    echo "Current assignment: $current_assignment"
    echo
}

# Function to update assignment in config file
update_assignment() {
    local new_assignment="$1"
    local config_file="$APP_DIR/config/config.env"
    
    # Create backup of config file
    cp "$config_file" "$config_file.backup"
    
    # Use sed to replace the ASSIGNMENT value
    if sed -i.tmp "s/^ASSIGNMENT=.*/ASSIGNMENT=\"$new_assignment\"/" "$config_file"; then
        rm -f "$config_file.tmp"
        echo "Assignment updated successfully!"
        echo "New assignment: $new_assignment"
    else
        echo "Error: Failed to update assignment in config file."
        # Restore backup
        mv "$config_file.backup" "$config_file"
        exit 1
    fi
    
    # Remove backup file
    rm -f "$config_file.backup"
}

# Function to run the updated application
run_application() {
    echo
    echo "Running the application with the new assignment..."
    echo "==========================================="
    
    # Change to app directory and run startup script
    cd "$APP_DIR"
    if [ -x "./startup.sh" ]; then
        ./startup.sh
    else
        echo "Error: startup.sh is not executable!"
        echo "Making it executable and trying again..."
        chmod +x ./startup.sh
        ./startup.sh
    fi
    
    # Return to original directory
    cd - > /dev/null
}

# Main execution
main() {
    # Find the app directory
    find_app_directory
    
    # Validate directory structure
    validate_directory
    
    # Show current assignment
    show_current_assignment
    
    # Prompt for new assignment name
    read -p "Enter the new assignment name: " new_assignment
    
    # Validate input
    if [ -z "$new_assignment" ]; then
        echo "Error: Assignment name cannot be empty!"
        exit 1
    fi
    
    # Update the assignment
    update_assignment "$new_assignment"
    
    # Ask if user wants to run the application
    echo
    read -p "Do you want to run the application now with the new assignment? (y/n): " run_now
    
    if [[ "$run_now" =~ ^[Yy]$ ]]; then
        run_application
    else
        echo "Assignment updated. You can run the application later using:"
        echo "  cd $APP_DIR && ./startup.sh"
    fi
    
    echo
    echo "Copilot script execution completed!"
}

# Run main function
main "$@"
