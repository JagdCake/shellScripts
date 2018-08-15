#!/bin/bash

### Description ###
# Choose between adding a new topic / notes on a topic or displaying all notes on a topic
# If adding a new topic, choose a name and enter a title for the first set of notes
# If adding notes, select a topic from all the added ones and enter a title 
# The script will generate formatted lines of text for the title, date, first note and the source
# The script will then open the notes file in your favorite text editor (default is 'neovim')
# If displaying notes, the script will open the file in the chosen program (default is 'less')
### ###

### Usage ###
# You can just create an alias for the script in '.bashrc' and run it from a terminal
    # alias take_notes='/path/to/./take_notes.sh'
    # $ take_notes
# You can create a symbolic link to the script from your home directory
    # ~$ ln -s /path/to/take_notes.sh
    # ~$ ./take_notes.sh
### ###

### Options ###
# path to notes folder
notes=~/Documents/text_files/notes/

# app for editing notes
app_edit() {
    nvim +"normal Gkka " "$1"
}

# app for reading notes
app_open() {
    less "$1"
}
### ###

# create the notes folder if it doesn't already exist
if [ ! -d "$notes" ]; then
    mkdir -p "$notes"
fi

generate_format() {
    # TODO Enhancement:
    # sanitize the title variable
    read -p "Enter a title: " title

    echo "Title: "$title"" >> "$notes"/"$topic"
    echo "$(date)" >> "$notes"/"$topic" 
    echo "- " >> "$notes"/"$topic" 
    echo -e "Source:\n" >> "$notes"/"$topic" 
}

add_notes() {
    generate_format
    app_edit "$notes"/"$topic"
}

add_topic() {
    read -p 'Enter a topic name: ' topic

    while [ -z "$topic" ]; do
        echo 'You need a name for the topic'
        add_topic
    done

    # removes tabs, leading and trailing whitespace from the file name
    topic=$(echo "$topic" | sed 's/^[ \t]*//;s/[ \t]*$//')

    # 'touch' doesn't overwrite already existing files 
    touch "$notes"/"$topic"
}

select_topic() {
    # use fuzzy search to select a topic
    topic="$(ls "$notes" | fzf)"
}

select_menu() {
    topics="$(ls -A "$notes")"

    # check to see of there are any topics in the notes folder
    if [ -z "$topics" ]; then
        add_topic &&
        add_notes
        select_menu
    else
        select choice in "Add new topic" "Add notes" "Show notes" "Quit"; do
            case "$choice" in 
                "Add new topic" )
                    add_topic &&
                    add_notes
                    break;;
                "Add notes" )
                    select_topic &&
                    add_notes
                    break;;
                "Show notes" )
                    select_topic &&
                    app_open "$notes"/"$topic"
                    break;;
                "Quit" )
                    exit;;
            esac
        done

        select_menu
    fi
}

select_menu

