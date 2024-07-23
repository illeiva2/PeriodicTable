#! /bin/bash
PSQL="psql -X --username=postgres --dbname=periodic_table --tuples-only -c"
FIT_SQL() {
    FIT_SQL_ATOMIC_MASS=$($PSQL "ALTER TABLE properties RENAME COLUMN weight TO atomic_mass")
    echo $FIT_SQL_ATOMIC_MASS
    FIT_SQL_MELTING=$($PSQL "ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius")
    echo $FIT_SQL_MELTING
    FIT_SQL_BOILING=$($PSQL "ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius")
    echo $FIT_SQL_BOILING
    FIT_SQL_MELTING_NOT_NULL=$($PSQL "ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL")
    echo $FIT_SQL_MELTING_NOT_NULL
    FIT_SQL_BOILING_NOT_NULL=$($PSQL "ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL")
    echo $FIT_SQL_BOILING_NOT_NULL
    FIT_SQL_ELEMENTS_UNIQUE=$($PSQL "ALTER TABLE elements ADD UNIQUE (symbol, name)")
    echo $FIT_SQL_ELEMENTS_UNIQUE
    FIT_SQL_FOREIGN_ATOMIC=$($PSQL "ALTER TABLE properties ADD FOREIGN KEY (atomic_number) REFERENCES elements (atomic_number)")
    echo $FIT_SQL_FOREIGN_ATOMIC
    FIT_SQL_CREATE_TYPES=$($PSQL "CREATE TABLE types (
        type_id INTEGER PRIMARY KEY,
        type VARCHAR NOT NULL
    )")
    echo $FIT_SQL_CREATE_TYPES
    FIT_SQL_ADD_TYPES=$($PSQL "INSERT INTO types (type_id, type) VALUES (1, 'nonmetal'), (2, 'metal'), (3, 'metalloid')")
    echo $FIT_SQL_ADD_TYPES
    FIT_SQL_ADD_TYPE_ID=$($PSQL "ALTER TABLE properties ADD COLUMN type_id INTEGER")
    echo $FIT_SQL_ADD_TYPE_ID
    FIT_SQL_FOREIGN_TYPE=$($PSQL "ALTER TABLE properties ADD FOREIGN KEY (type_id) REFERENCES types (type_id)")
    echo $FIT_SQL_FOREIGN_TYPE
    SET_SYMBOL_NOT_NULL=$($PSQL "ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL")
    echo $SET_SYMBOL_NOT_NULL
    SET_SYMBOL_NOT_NULL=$($PSQL "ALTER TABLE elements ALTER COLUMN name SET NOT NULL")
    echo $SET_SYMBOL_NOT_NULL
    SET_TYPE_ID_NOT_NULL=$($PSQL "ALTER TABLE types ALTER COLUMN type_id SET NOT NULL")
    echo $SET_TYPE_ID_NOT_NULL
    SET_TYPE_CONSTRAINT=$($PSQL "ALTER TABLE properties ADD FOREIGN KEY(type_id) REFERENCES types(type_id)")
    echo $SET_TYPE_CONSTRAINT
}
# •	Each row in your properties table should have a type_id value that links to the correct type from the types table
UPDATE_TYPES() {
    ELEMENTS_TO_UPDATE=$($PSQL "SELECT type, atomic_number FROM properties")
    echo "$ELEMENTS_TO_UPDATE" | while read TYPE BAR ELEMENT_ID
    do
        TYPE_ID=$($PSQL "SELECT type_id FROM types WHERE type='$TYPE'")
        echo $TYPE_ID
        UPDATE_TYPE=$($PSQL "UPDATE properties SET type_id=$TYPE_ID WHERE atomic_number=$ELEMENT_ID")
        echo "Se actualizó la información del elemento de tipo $TYPE por el de nuermo de elemnto: $ELEMENT_ID con resultado: $UPDATE_TYPE"
    done
}
# •	You should capitalize the first letter of all the symbol values in the elements table. Be careful to only capitalize the letter and not change any others
CAPITALIZE_SYMBOLS() {
    SYMBOLS=$($PSQL "SELECT atomic_number, symbol, name FROM elements")
    echo "$SYMBOLS" | while read ELEMENT_ID BAR SYMBOL BAR ELEMENT
    do
        SYMBOL="$(echo "$SYMBOL" | sed 's/./\U&/')"
        UPDATE_SYMBOL=$($PSQL "UPDATE elements SET symbol='$SYMBOL' WHERE atomic_number=$ELEMENT_ID")
        echo $UPDATE_SYMBOL
    done
}
# •	You should remove all the trailing zeros after the decimals from each row of the atomic_mass column. You may need to adjust a data type to DECIMAL for this. The final values they should be are in the atomic_mass.txt file
REMOVE_ZEROS() {
    SET_DECIMAL=$($PSQL "ALTER TABLE properties ALTER COLUMN atomic_mass TYPE decimal")
    echo " " >> atomic_mass.txt
    cat atomic_mass.txt | while  read  ATOMIC_NUMBER BAR MASS
    do
        echo $ATOMIC_NUMBER
        echo $MASS
        if [[ ! $MASS == 'atomic_mass' ]]
        then
            UPDATE_MASS=$($PSQL "UPDATE properties SET atomic_mass=$MASS WHERE atomic_number=$ATOMIC_NUMBER")
            echo "$UPDATE_MASS de $ATOMIC_NUMBER"
        fi
    done
}
INSERT_NEW_ELEMENTS() {
    # •	You should add the element with atomic number 9 to your database. Its name is Fluorine, symbol is F, mass is 18.998, melting point is -220, boiling point is -188.1, and it's a nonmetal
    INSERTTING_FLUORINE_ELEMENTS=$($PSQL "INSERT INTO elements (atomic_number, symbol, name) VALUES (9, 'F', 'Fluorine')")
    echo $INSERTTING_FLUORINE_ELEMENTS
    INSERTING_FLUORINE_PROPERTIES=$($PSQL "INSERT INTO properties(atomic_mass, atomic_number, type, melting_point_celsius, boiling_point_celsius) VALUES(0, 9, 'nonmetal', -220, -188.1)")
    echo $INSERTING_FLUORINE_PROPERTIES
    # •	You should add the element with atomic number 10 to your database. Its name is Neon, symbol is Ne, mass is 20.18, melting point is -248.6, boiling point is -246.1, and it's a nonmetal
    INSERTTING_NEON_ELEMENTS=$($PSQL "INSERT INTO elements (atomic_number, symbol, name) VALUES (10, 'Ne', 'Neon')")
    echo $INSERTTING_NEON_ELEMENTS
    INSERTING_NEON_PROPERTIES=$($PSQL "INSERT INTO properties(atomic_mass, atomic_number, type, melting_point_celsius, boiling_point_celsius) VALUES(0, 10, 'nonmetal', -248.6, -246.1)")
    echo $INSERTING_NEON_PROPERTIES
}
DELETE_INEXISTENT() {
    DELETE_PROPERTIES=$($PSQL "DELETE FROM properties WHERE atomic_number=1000")
    DELETE_ELEMENT=$($PSQL "DELETE FROM elements WHERE atomic_number=1000")
}
DELETE_TYPE_COLUMN() {
    DELETE_TYPE=$($PSQL "ALTER TABLE properties DROP COLUMN type")
    echo "resultado del borrado de columna tipo: $DELETE_TYPE"
}
DELETE_INEXISTENT
FIT_SQL
NEW_EXIST=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='F'")
if [[ -z $NEW_EXIST ]]
then
    INSERT_NEW_ELEMENTS
fi
UPDATE_TYPES
REMOVE_ZEROS
CAPITALIZE_SYMBOLS
DELETE_TYPE_COLUMN
SET_TYPE_ID_NOT_NULLP=$($PSQL "ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL")
echo $SET_TYPE_ID_NOT_NULLP