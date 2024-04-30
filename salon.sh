#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n\nWelcome to My Salon, how can I help you?\n"

MAIN_MENU() {
  if [[ $1 ]]; then
    echo -e $1
  fi
  echo -e "1) cut\n2) color\n3) trim"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1|2|3) SERVICE $SERVICE_ID_SELECTED ;;
    *) MAIN_MENU "\nI could not find that service. What would you like today?" ;;
  esac
}

SERVICE() {
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $1") 

  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE';")

  if [[ -z $CUSTOMER_NAME ]]; then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE');")
  fi

  echo -e "\nWhat time would you like your $(echo $SERVICE_NAME | sed 's/^ *//'), $(echo $CUSTOMER_NAME | sed 's/^ *//')?"
  read SERVICE_TIME
  
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $1, '$SERVICE_TIME');")

  echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed 's/^ *//') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed 's/^ *//')."
}

MAIN_MENU


