#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 =~ ^[0-9]+$ ]]
then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
  ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
  ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties INNER JOIN elements USING(atomic_number) WHERE atomic_number = $ATOMIC_NUMBER")
  ELEMENT_TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) INNER JOIN elements USING(atomic_number) WHERE atomic_number = $ATOMIC_NUMBER")
  MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
elif [[ $1 =~ ^[a-Z]$ || $1 =~ ^[a-Z][a-Z]$ ]]
then
  ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$1'")
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROm elements WHERE symbol = '$ELEMENT_SYMBOL'")
  ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE symbol = '$ELEMENT_SYMBOL'")
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties INNER JOIN elements USING(atomic_number) WHERE symbol = '$ELEMENT_SYMBOL'")
  ELEMENT_TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) INNER JOIN elements USING(atomic_number) WHERE symbol = '$ELEMENT_SYMBOL'")
  MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties INNER JOIN elements USING(atomic_number) WHERE symbol = '$ELEMENT_SYMBOL'")
  BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) WHERE symbol = '$ELEMENT_SYMBOL'")
elif [[ $1 =~ ^[a-Z]+$ ]]
then
  ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE name = '$1'")
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$ELEMENT_NAME'")
  ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name = '$ELEMENT_NAME'")
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties INNER JOIN elements USING(atomic_number) WHERE name = '$ELEMENT_NAME'")
  ELEMENT_TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) INNER JOIN elements USING(atomic_number) WHERE name = '$ELEMENT_NAME'")
  MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties INNER JOIN elements USING(atomic_number) WHERE name = '$ELEMENT_NAME'")
  BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) WHERE name = '$ELEMENT_NAME'")
fi

REPORT_RESULT() {
  echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
}

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
elif [[ -z $ATOMIC_NUMBER || -z $ELEMENT_SYMBOL || -z $ELEMENT_NAME ]]
then
  echo "I could not find that element in the database."
else
  REPORT_RESULT
fi
