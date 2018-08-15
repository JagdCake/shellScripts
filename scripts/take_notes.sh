#!/bin/bash

### Description ###
# Choose between adding a new topic / notes on a topic or displaying all notes on a topic
# If adding a new topic, choose a name and enter a title for the first set of notes
# If adding notes, select a topic from all the added ones and enter a title 
# The script will generate formatted lines of text for the title, date, first note and the source
# The script will then open the notes file in your favorite text editor (default is 'neovim')
# If displaying notes, the script will open the file in the chosen program (default is 'less')
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
