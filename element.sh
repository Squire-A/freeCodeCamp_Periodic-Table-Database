#! /bin/bash
# A program to provide details on a provided element

PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
fi

if [[ $1 =~ ^[0-9]+$ ]]
then
  # lookup element with atomic number and get required info for output
  ELEMENT_DATA=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements JOIN properties USING (atomic_number) JOIN types USING (type_id) WHERE atomic_number = $1")
elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
then
  # lookup element nased on symbol
  ELEMENT_DATA=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements JOIN properties USING (atomic_number) JOIN types USING (type_id) WHERE symbol = '$1'")
fi

if [[ -z $ELEMENT_DATA ]]
then
  echo "I could not find that element in the database."
else
  IFS="|" read -r ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE <<< $ELEMENT_DATA
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi