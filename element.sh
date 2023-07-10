#!/bin/bash

# Check if an argument was provided
if [ $# -eq 0 ]; then
  echo "Please provide an element as an argument."
  exit 0
fi

# Query the database for the given element
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
query="SELECT elements.atomic_number, elements.name, elements.symbol, types.type, elements.atomic_mass, elements.melting_point_celsius, elements.boiling_point_celsius FROM elements JOIN types ON elements.atomic_number = types.type_id WHERE elements.atomic_number = $1 OR elements.symbol = '$1' OR elements.name ILIKE '%$1%';"
result=$($PSQL "$query")

# Check if the element exists in the database
if [ -z "$result" ]; then
  echo "I could not find that element in the database."
  exit 0
fi

# Parse the query result and display the element information
IFS='|' read -ra info <<< "$result"
atomic_number=${info[0]}
name=${info[1]}
symbol=${info[2]}
type=${info[3]}
atomic_mass=${info[4]}
melting_point=${info[5]}
boiling_point=${info[6]}

echo "The element with atomic number $atomic_number is $name ($symbol)."
echo "It's a $type, with a mass of $atomic_mass amu."
echo "$name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
