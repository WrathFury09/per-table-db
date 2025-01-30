#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]; then
    echo "Please provide an element as an argument."
    exit 0
fi

INPUT=$1

# Check if input is a number (atomic number)
if [[ $INPUT =~ ^[0-9]+$ ]]; then
    ELEMENT_INFO=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements JOIN properties ON elements.atomic_number = properties.atomic_number JOIN types ON properties.type_id = types.type_id WHERE elements.atomic_number = $INPUT;")
else
    # Check if input is a symbol or name
    ELEMENT_INFO=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements JOIN properties ON elements.atomic_number = properties.atomic_number JOIN types ON properties.type_id = types.type_id WHERE elements.symbol = '$INPUT' OR elements.name = '$INPUT';")
fi

if [[ -z $ELEMENT_INFO ]]; then
    echo "I could not find that element in the database."
else
    echo "$ELEMENT_INFO" | while IFS='|' read -r ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT; do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
fi
