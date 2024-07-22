if [[ -z $1]]
then
    echo "Please provide an element as an argument."
else
    if [[ $1 =~ ^[0-9]+$ ]]
    then
        ELEMENT=$($PSQL "SELECT name, type, atomic_mass, melting_point_celcius, boiling_point_celcius FROM elements e INNER JOIN properties p ON e.atomic_number = p.atomic_number  INNER JOIN types t ON p.type_id = t.type_id WHERE atomic_number=$1")
        echo $ELEMENT | read ATOMIC_NUMBER BAR SYMBOL BAR NAME