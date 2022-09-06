#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
if [[ -z $1 ]]
  then
    echo Please provide an element as an argument.
  exit
fi  

if [[ $1 =~ [0-9] ]]
  then
    ELEMENT_INFO="$($PSQL "SELECT * FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE  (atomic_number=$1)")"
  else
    ELEMENT_INFO="$($PSQL "SELECT * FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE (name='$1')  OR (symbol='$1')")"
fi
if [[ -z $ELEMENT_INFO && ! -z $1 ]]
  then 
    echo I could not find that element in the database.
  else
  echo $ELEMENT_INFO | while IFS=" | " read TYPE_ID ATOMIC_N ATOMIC_M MELTING BOILING SYMBOL NAME TYPE
    do
      echo "The element with atomic number $ATOMIC_N is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_M amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
fi
