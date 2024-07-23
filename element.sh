#! /bin/bash
PSQL="psql -X --username=postgres --dbname=periodic_table --tuples-only -c"
if [[ -z $1 ]]
then
    echo "Please provide an element as an argument."
else
    if [[ $1 =~ ^[0-9]+$ ]]
    then
        ELEMENT=$($PSQL "SELECT e.atomic_number, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol FROM elements e INNER JOIN properties p ON e.atomic_number = p.atomic_number INNER JOIN types t ON p.type_id = t.type_id WHERE e.atomic_number=$1")
        if [[ -z $ELEMENT ]]
        then
            echo "I could not find that element in the database."
        else
            read -r A_NUMBER BAR NAME BAR TYPE BAR ATOMIC_MASS BAR MELTING BAR BOILING BAR SYMBOL <<< "$ELEMENT"
            echo "The element with atomic number $A_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
        fi
    elif [[ $1 =~ ^[a-zA-Z]{1,2}$ ]]
    then
        ELEMENT=$($PSQL "SELECT e.atomic_number, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol FROM elements e INNER JOIN properties p ON e.atomic_number = p.atomic_number INNER JOIN types t ON p.type_id = t.type_id WHERE symbol='$1'")
        if [[ -z $ELEMENT ]]
        then
            echo "I could not find that element in the database."
        else
            read -r A_NUMBER BAR NAME BAR TYPE BAR ATOMIC_MASS BAR MELTING BAR BOILING BAR SYMBOL <<< "$ELEMENT"
            echo "The element with atomic number $A_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
        fi
    elif [[ $1 =~ ^[a-zA-Z]{3,}$ ]]
    then
        ELEMENT=$($PSQL "SELECT e.atomic_number, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol FROM elements e INNER JOIN properties p ON e.atomic_number = p.atomic_number INNER JOIN types t ON p.type_id = t.type_id WHERE name='$1'")
        if [[ -z $ELEMENT ]]
        then
            echo "I could not find that element in the database."
        else
            read -r A_NUMBER BAR NAME BAR TYPE BAR ATOMIC_MASS BAR MELTING BAR BOILING BAR SYMBOL <<< "$ELEMENT"
            echo "The element with atomic number $A_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
        fi
    else
        echo "Please provide a valid element as an argument."
    fi
fi
