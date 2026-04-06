;;; ======================================================
;;; CAR PURCHASE ADVISOR - WORKING VERSION
;;; ======================================================

(deftemplate user-need
   (slot category)
   (slot value)
)

(deftemplate car-rec
   (slot model)
   (slot type)
   (slot price)
   (slot fuel)
   (slot reliability)
   (slot reason)
   (slot confidence)
)

(deftemplate question
   (slot id)
   (slot text)
   (slot options)
   (slot asked)
)

(deffacts initial-questions
   (question (id budget) (text "What is your budget?") (options "low | medium | high | premium") (asked no))
   (question (id purpose) (text "What is the main purpose?") (options "city | highway | offroad | family | work") (asked no))
   (question (id mileage) (text "Expected annual mileage?") (options "low | medium | high") (asked no))
   (question (id fuel) (text "Preferred fuel type?") (options "petrol | diesel | electric | hybrid") (asked no))
   (question (id transmission) (text "Preferred transmission?") (options "manual | automatic | cvt | robot") (asked no))
   (question (id drive) (text "Preferred drive type?") (options "front | rear | 4wd") (asked no))
   (question (id passengers) (text "How many passengers?") (options "2-3 | 4-5 | 6-7+") (asked no))
   (question (id cargo) (text "Cargo space needed?") (options "small | medium | large") (asked no))
   (question (id age) (text "Preferred car age?") (options "new | young | mid | old") (asked no))
   (question (id maintenance) (text "Affordable maintenance cost?") (options "low | medium | high") (asked no))
)

(defrule welcome
   (declare (salience 1000))
   (not (welcome-shown))
   =>
   (assert (welcome-shown))
   (printout t crlf)
   (printout t "========================================" crlf)
   (printout t "  CAR PURCHASE ADVISOR" crlf)
   (printout t "========================================" crlf)
   (printout t crlf)
)

(defrule ask-question
   ?q <- (question (id ?id) (text ?text) (options ?opts) (asked no))
   (not (user-need (category ?id)))
   =>
   (retract ?q)
   (printout t crlf "Q: " ?text crlf)
   (printout t "   Options: " ?opts crlf)
   (printout t "   Your answer: ")
   (bind ?answer (readline))
   (bind ?answer (lowcase ?answer))
   
   (if (or (eq ?answer "low") (eq ?answer "medium") (eq ?answer "high")
           (eq ?answer "premium") (eq ?answer "city") (eq ?answer "highway")
           (eq ?answer "offroad") (eq ?answer "family") (eq ?answer "work")
           (eq ?answer "petrol") (eq ?answer "diesel") (eq ?answer "electric")
           (eq ?answer "hybrid") (eq ?answer "manual") (eq ?answer "automatic")
           (eq ?answer "cvt") (eq ?answer "robot") (eq ?answer "front")
           (eq ?answer "rear") (eq ?answer "4wd") (eq ?answer "2-3")
           (eq ?answer "4-5") (eq ?answer "6-7+") (eq ?answer "small")
           (eq ?answer "medium") (eq ?answer "large") (eq ?answer "new")
           (eq ?answer "young") (eq ?answer "mid") (eq ?answer "old"))
      then
      (assert (user-need (category ?id) (value ?answer)))
      (printout t "   -> Selected: " ?answer crlf)
      (assert (question (id ?id) (text ?text) (options ?opts) (asked yes)))
   else
      (printout t "   Invalid. Enter: " ?opts crlf)
      (assert (question (id ?id) (text ?text) (options ?opts) (asked no)))
   )
)

;;; ======================================================
;;; RULES - Hyundai Creta (הכÿ ְֲ״ָױ מעגועמג)
;;; ======================================================

(defrule recommend-creta
   (declare (salience 100))
   (user-need (category budget) (value "medium"))
   (user-need (category purpose) (value "family"))
   (user-need (category drive) (value "4wd"))
   (user-need (category transmission) (value "automatic"))
   (user-need (category fuel) (value "petrol"))
   (user-need (category passengers) (value "2-3"))
   (user-need (category cargo) (value "medium"))
   (user-need (category age) (value "mid"))
   (user-need (category maintenance) (value "medium"))
   (user-need (category mileage) (value "medium"))
   =>
   (assert (car-rec 
            (model "Hyundai Creta")
            (type "Compact SUV")
            (price "1.2M - 1.8M RUB")
            (fuel "Petrol")
            (reliability 8)
            (reason "Great value, 4WD, automatic transmission, perfect for family")
            (confidence 90)))
   (printout t crlf "*** RECOMMENDATION: Hyundai Creta ***" crlf)
)

;;; ======================================================
;;; DISPLAY RULES
;;; ======================================================

(defrule show-recommendations
   (declare (salience -50))
   (car-rec (model ?model) (type ?type) (price ?price) (fuel ?fuel) 
            (reliability ?rel) (reason ?reason) (confidence ?conf))
   (not (rec-shown))
   =>
   (assert (rec-shown))
   (printout t crlf)
   (printout t "========================================" crlf)
   (printout t "  RECOMMENDATION" crlf)
   (printout t "========================================" crlf)
   (printout t "Car: " ?model crlf)
   (printout t "Type: " ?type crlf)
   (printout t "Price: " ?price crlf)
   (printout t "Fuel: " ?fuel crlf)
   (printout t "Reliability: " ?rel "/10" crlf)
   (printout t "Confidence: " ?conf "%" crlf)
   (printout t "Why? " ?reason crlf)
   (printout t "========================================" crlf crlf)
)

(defrule final-advice
   (declare (salience -100))
   (rec-shown)
   (not (final-shown))
   =>
   (assert (final-shown))
   (printout t "Thank you for using Car Purchase Advisor!" crlf)
   (printout t "========================================" crlf)
   (halt)
)