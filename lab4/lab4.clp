;;; ======================================================
;;; EXPERT SYSTEM: CAR PURCHASE ADVISOR
;;; 30 rules - each checks all 10 parameters
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
;;; RULE 1: Hyundai Solaris / KIA Rio
;;; ======================================================
(defrule recommend-solaris-rio
   (declare (salience 100))
   (user-need (category budget) (value "low"))
   (user-need (category purpose) (value "city"))
   (user-need (category mileage) (value "low"))
   (user-need (category fuel) (value "petrol"))
   (user-need (category transmission) (value "manual"))
   (user-need (category drive) (value "front"))
   (user-need (category passengers) (value "2-3"))
   (user-need (category cargo) (value "small"))
   (user-need (category age) (value "young"))
   (user-need (category maintenance) (value "low"))
   =>
   (assert (car-rec 
            (model "Hyundai Solaris / KIA Rio")
            (type "Budget City Hatchback")
            (price "500k - 900k RUB")
            (fuel "Petrol")
            (reliability 8)
            (reason "Excellent value, low maintenance, perfect for city")
            (confidence 95)))
   (printout t crlf "*** RECOMMENDATION: Hyundai Solaris / KIA Rio ***" crlf)
)

;;; ======================================================
;;; RULE 2: Lada Vesta
;;; ======================================================
(defrule recommend-vesta
   (declare (salience 95))
   (user-need (category budget) (value "low"))
   (user-need (category purpose) (value "family"))
   (user-need (category mileage) (value "low"))
   (user-need (category fuel) (value "petrol"))
   (user-need (category transmission) (value "manual"))
   (user-need (category drive) (value "front"))
   (user-need (category passengers) (value "4-5"))
   (user-need (category cargo) (value "medium"))
   (user-need (category age) (value "new"))
   (user-need (category maintenance) (value "low"))
   =>
   (assert (car-rec 
            (model "Lada Vesta SW / Sedan")
            (type "Budget Family Car")
            (price "700k - 1.2M RUB")
            (fuel "Petrol")
            (reliability 7)
            (reason "Spacious, large trunk, cheap spare parts")
            (confidence 90)))
   (printout t crlf "*** RECOMMENDATION: Lada Vesta ***" crlf)
)

;;; ======================================================
;;; RULE 3: Toyota Camry
;;; ======================================================
(defrule recommend-camry
   (declare (salience 95))
   (user-need (category budget) (value "high"))
   (user-need (category purpose) (value "highway"))
   (user-need (category mileage) (value "high"))
   (user-need (category fuel) (value "petrol"))
   (user-need (category transmission) (value "automatic"))
   (user-need (category drive) (value "front"))
   (user-need (category passengers) (value "4-5"))
   (user-need (category cargo) (value "medium"))
   (user-need (category age) (value "new"))
   (user-need (category maintenance) (value "medium"))
   =>
   (assert (car-rec 
            (model "Toyota Camry")
            (type "Business Sedan")
            (price "2.5M - 3.5M RUB")
            (fuel "Petrol")
            (reliability 9)
            (reason "Legendary reliability, comfortable for long trips")
            (confidence 98)))
   (printout t crlf "*** RECOMMENDATION: Toyota Camry ***" crlf)
)

;;; ======================================================
;;; RULE 4: Toyota RAV4
;;; ======================================================
(defrule recommend-rav4
   (declare (salience 95))
   (user-need (category budget) (value "high"))
   (user-need (category purpose) (value "family"))
   (user-need (category mileage) (value "medium"))
   (user-need (category fuel) (value "petrol"))
   (user-need (category transmission) (value "automatic"))
   (user-need (category drive) (value "4wd"))
   (user-need (category passengers) (value "4-5"))
   (user-need (category cargo) (value "medium"))
   (user-need (category age) (value "new"))
   (user-need (category maintenance) (value "medium"))
   =>
   (assert (car-rec 
            (model "Toyota RAV4")
            (type "Compact Crossover")
            (price "2.8M - 4M RUB")
            (fuel "Petrol / Hybrid")
            (reliability 10)
            (reason "Best-selling crossover, excellent reliability")
            (confidence 98)))
   (printout t crlf "*** RECOMMENDATION: Toyota RAV4 ***" crlf)
)

;;; ======================================================
;;; RULE 5: Hyundai Creta
;;; ======================================================
(defrule recommend-creta
   (declare (salience 98))
   (user-need (category budget) (value "medium"))
   (user-need (category purpose) (value "family"))
   (user-need (category mileage) (value "medium"))
   (user-need (category fuel) (value "petrol"))
   (user-need (category transmission) (value "automatic"))
   (user-need (category drive) (value "4wd"))
   (user-need (category passengers) (value "2-3"))
   (user-need (category cargo) (value "medium"))
   (user-need (category age) (value "mid"))
   (user-need (category maintenance) (value "medium"))
   =>
   (assert (car-rec 
            (model "Hyundai Creta")
            (type "Budget Crossover")
            (price "1.2M - 1.8M RUB")
            (fuel "Petrol")
            (reliability 8)
            (reason "Great value, good ground clearance, low costs")
            (confidence 95)))
   (printout t crlf "*** RECOMMENDATION: Hyundai Creta ***" crlf)
)

;;; ======================================================
;;; RULE 6: Tesla Model 3
;;; ======================================================
(defrule recommend-tesla
   (declare (salience 90))
   (user-need (category budget) (value "premium"))
   (user-need (category purpose) (value "city"))
   (user-need (category mileage) (value "low"))
   (user-need (category fuel) (value "electric"))
   (user-need (category transmission) (value "automatic"))
   (user-need (category drive) (value "rear"))
   (user-need (category passengers) (value "4-5"))
   (user-need (category cargo) (value "medium"))
   (user-need (category age) (value "new"))
   (user-need (category maintenance) (value "low"))
   =>
   (assert (car-rec 
            (model "Tesla Model 3")
            (type "Electric Sedan")
            (price "3M - 5M RUB")
            (fuel "Electric")
            (reliability 8)
            (reason "Zero emissions, low running costs, instant torque")
            (confidence 92)))
   (printout t crlf "*** RECOMMENDATION: Tesla Model 3 ***" crlf)
)

;;; ======================================================
;;; RULE 7: Toyota Land Cruiser
;;; ======================================================
(defrule recommend-landcruiser
   (declare (salience 92))
   (user-need (category budget) (value "premium"))
   (user-need (category purpose) (value "offroad"))
   (user-need (category mileage) (value "medium"))
   (user-need (category fuel) (value "diesel"))
   (user-need (category transmission) (value "automatic"))
   (user-need (category drive) (value "4wd"))
   (user-need (category passengers) (value "4-5"))
   (user-need (category cargo) (value "large"))
   (user-need (category age) (value "new"))
   (user-need (category maintenance) (value "high"))
   =>
   (assert (car-rec 
            (model "Toyota Land Cruiser 300")
            (type "Premium SUV")
            (price "8M - 12M RUB")
            (fuel "Diesel")
            (reliability 10)
            (reason "Ultimate off-road capability, legendary durability")
            (confidence 98)))
   (printout t crlf "*** RECOMMENDATION: Toyota Land Cruiser ***" crlf)
)

;;; ======================================================
;;; RULE 8: UAZ Patriot
;;; ======================================================
(defrule recommend-uaz
   (declare (salience 85))
   (user-need (category budget) (value "low"))
   (user-need (category purpose) (value "offroad"))
   (user-need (category mileage) (value "low"))
   (user-need (category fuel) (value "petrol"))
   (user-need (category transmission) (value "manual"))
   (user-need (category drive) (value "4wd"))
   (user-need (category passengers) (value "4-5"))
   (user-need (category cargo) (value "large"))
   (user-need (category age) (value "old"))
   (user-need (category maintenance) (value "low"))
   =>
   (assert (car-rec 
            (model "UAZ Patriot")
            (type "Budget Off-road SUV")
            (price "1M - 1.5M RUB")
            (fuel "Petrol")
            (reliability 6)
            (reason "Cheapest real off-roader, simple mechanics")
            (confidence 88)))
   (printout t crlf "*** RECOMMENDATION: UAZ Patriot ***" crlf)
)

;;; ======================================================
;;; RULE 9: Ford Transit
;;; ======================================================
(defrule recommend-transit
   (declare (salience 88))
   (user-need (category budget) (value "low"))
   (user-need (category purpose) (value "work"))
   (user-need (category mileage) (value "high"))
   (user-need (category fuel) (value "diesel"))
   (user-need (category transmission) (value "manual"))
   (user-need (category drive) (value "rear"))
   (user-need (category passengers) (value "2-3"))
   (user-need (category cargo) (value "large"))
   (user-need (category age) (value "mid"))
   (user-need (category maintenance) (value "low"))
   =>
   (assert (car-rec 
            (model "Ford Transit")
            (type "Commercial Van")
            (price "800k - 2.5M RUB")
            (fuel "Diesel")
            (reliability 7)
            (reason "Large cargo capacity, practical for business")
            (confidence 90)))
   (printout t crlf "*** RECOMMENDATION: Ford Transit ***" crlf)
)

;;; ======================================================
;;; RULE 10: BMW 5-Series
;;; ======================================================
(defrule recommend-bmw
   (declare (salience 85))
   (user-need (category budget) (value "premium"))
   (user-need (category purpose) (value "highway"))
   (user-need (category mileage) (value "high"))
   (user-need (category fuel) (value "diesel"))
   (user-need (category transmission) (value "automatic"))
   (user-need (category drive) (value "rear"))
   (user-need (category passengers) (value "4-5"))
   (user-need (category cargo) (value "medium"))
   (user-need (category age) (value "young"))
   (user-need (category maintenance) (value "high"))
   =>
   (assert (car-rec 
            (model "BMW 5-Series")
            (type "German Premium Sedan")
            (price "4M - 7M RUB")
            (fuel "Diesel")
            (reliability 8)
            (reason "Excellent driving dynamics, premium interior")
            (confidence 90)))
   (printout t crlf "*** RECOMMENDATION: BMW 5-Series ***" crlf)
)

;;; ======================================================
;;; RULE 11: Toyota Sienna
;;; ======================================================
(defrule recommend-sienna
   (declare (salience 92))
   (user-need (category budget) (value "high"))
   (user-need (category purpose) (value "family"))
   (user-need (category mileage) (value "medium"))
   (user-need (category fuel) (value "hybrid"))
   (user-need (category transmission) (value "automatic"))
   (user-need (category drive) (value "front"))
   (user-need (category passengers) (value "6-7+"))
   (user-need (category cargo) (value "large"))
   (user-need (category age) (value "new"))
   (user-need (category maintenance) (value "medium"))
   =>
   (assert (car-rec 
            (model "Toyota Sienna")
            (type "Minivan")
            (price "4M - 6M RUB")
            (fuel "Hybrid")
            (reliability 9)
            (reason "Maximum passenger and cargo space, fuel efficient")
            (confidence 95)))
   (printout t crlf "*** RECOMMENDATION: Toyota Sienna ***" crlf)
)

;;; ======================================================
;;; RULE 12: Skoda Octavia Diesel
;;; ======================================================
(defrule recommend-octavia
   (declare (salience 85))
   (user-need (category budget) (value "medium"))
   (user-need (category purpose) (value "highway"))
   (user-need (category mileage) (value "high"))
   (user-need (category fuel) (value "diesel"))
   (user-need (category transmission) (value "manual"))
   (user-need (category drive) (value "front"))
   (user-need (category passengers) (value "4-5"))
   (user-need (category cargo) (value "large"))
   (user-need (category age) (value "mid"))
   (user-need (category maintenance) (value "low"))
   =>
   (assert (car-rec 
            (model "Skoda Octavia Diesel")
            (type "Diesel Wagon")
            (price "1.5M - 2.5M RUB")
            (fuel "Diesel")
            (reliability 8)
            (reason "Excellent fuel economy for high mileage, huge trunk")
            (confidence 92)))
   (printout t crlf "*** RECOMMENDATION: Skoda Octavia ***" crlf)
)

;;; ======================================================
;;; RULE 13: Mazda MX-5
;;; ======================================================
(defrule recommend-mx5
   (declare (salience 80))
   (user-need (category budget) (value "high"))
   (user-need (category purpose) (value "city"))
   (user-need (category mileage) (value "low"))
   (user-need (category fuel) (value "petrol"))
   (user-need (category transmission) (value "manual"))
   (user-need (category drive) (value "rear"))
   (user-need (category passengers) (value "2-3"))
   (user-need (category cargo) (value "small"))
   (user-need (category age) (value "new"))
   (user-need (category maintenance) (value "medium"))
   =>
   (assert (car-rec 
            (model "Mazda MX-5")
            (type "Sports Car")
            (price "2.5M - 3.5M RUB")
            (fuel "Petrol")
            (reliability 9)
            (reason "Lightweight, rear-wheel drive, pure driving enjoyment")
            (confidence 88)))
   (printout t crlf "*** RECOMMENDATION: Mazda MX-5 ***" crlf)
)

;;; ======================================================
;;; RULE 14: Toyota Corolla Hybrid
;;; ======================================================
(defrule recommend-corolla-hybrid
   (declare (salience 88))
   (user-need (category budget) (value "medium"))
   (user-need (category purpose) (value "city"))
   (user-need (category mileage) (value "medium"))
   (user-need (category fuel) (value "hybrid"))
   (user-need (category transmission) (value "automatic"))
   (user-need (category drive) (value "front"))
   (user-need (category passengers) (value "4-5"))
   (user-need (category cargo) (value "medium"))
   (user-need (category age) (value "new"))
   (user-need (category maintenance) (value "low"))
   =>
   (assert (car-rec 
            (model "Toyota Corolla Hybrid")
            (type "Hybrid Sedan")
            (price "2M - 2.8M RUB")
            (fuel "Hybrid")
            (reliability 9)
            (reason "Excellent fuel economy in city traffic")
            (confidence 94)))
   (printout t crlf "*** RECOMMENDATION: Toyota Corolla Hybrid ***" crlf)
)

;;; ======================================================
;;; RULE 15: Volkswagen Polo
;;; ======================================================
(defrule recommend-polo
   (declare (salience 85))
   (user-need (category budget) (value "low"))
   (user-need (category purpose) (value "highway"))
   (user-need (category mileage) (value "high"))
   (user-need (category fuel) (value "petrol"))
   (user-need (category transmission) (value "manual"))
   (user-need (category drive) (value "front"))
   (user-need (category passengers) (value "4-5"))
   (user-need (category cargo) (value "medium"))
   (user-need (category age) (value "young"))
   (user-need (category maintenance) (value "low"))
   =>
   (assert (car-rec 
            (model "Volkswagen Polo")
            (type "Budget Sedan")
            (price "800k - 1.1M RUB")
            (fuel "Petrol")
            (reliability 8)
            (reason "German engineering, good for highway")
            (confidence 87)))
   (printout t crlf "*** RECOMMENDATION: Volkswagen Polo ***" crlf)
)

;;; ======================================================
;;; RULE 16: Mitsubishi Outlander
;;; ======================================================
(defrule recommend-outlander
   (declare (salience 88))
   (user-need (category budget) (value "medium"))
   (user-need (category purpose) (value "family"))
   (user-need (category mileage) (value "medium"))
   (user-need (category fuel) (value "petrol"))
   (user-need (category transmission) (value "cvt"))
   (user-need (category drive) (value "4wd"))
   (user-need (category passengers) (value "6-7+"))
   (user-need (category cargo) (value "large"))
   (user-need (category age) (value "mid"))
   (user-need (category maintenance) (value "medium"))
   =>
   (assert (car-rec 
            (model "Mitsubishi Outlander")
            (type "7-Seater SUV")
            (price "2M - 2.8M RUB")
            (fuel "Petrol")
            (reliability 8)
            (reason "Affordable 7-seater SUV with 4WD")
            (confidence 89)))
   (printout t crlf "*** RECOMMENDATION: Mitsubishi Outlander ***" crlf)
)

;;; ======================================================
;;; RULE 17: Suzuki Vitara
;;; ======================================================
(defrule recommend-vitara
   (declare (salience 86))
   (user-need (category budget) (value "medium"))
   (user-need (category purpose) (value "offroad"))
   (user-need (category mileage) (value "low"))
   (user-need (category fuel) (value "petrol"))
   (user-need (category transmission) (value "manual"))
   (user-need (category drive) (value "4wd"))
   (user-need (category passengers) (value "4-5"))
   (user-need (category cargo) (value "medium"))
   (user-need (category age) (value "young"))
   (user-need (category maintenance) (value "low"))
   =>
   (assert (car-rec 
            (model "Suzuki Vitara")
            (type "Compact SUV")
            (price "1.5M - 2.2M RUB")
            (fuel "Petrol")
            (reliability 9)
            (reason "Lightweight, real 4WD, good fuel economy")
            (confidence 90)))
   (printout t crlf "*** RECOMMENDATION: Suzuki Vitara ***" crlf)
)

;;; ======================================================
;;; RULE 18: Chery Tiggo 7 Pro
;;; ======================================================
(defrule recommend-chery
   (declare (salience 80))
   (user-need (category budget) (value "medium"))
   (user-need (category purpose) (value "family"))
   (user-need (category mileage) (value "low"))
   (user-need (category fuel) (value "petrol"))
   (user-need (category transmission) (value "cvt"))
   (user-need (category drive) (value "front"))
   (user-need (category passengers) (value "4-5"))
   (user-need (category cargo) (value "medium"))
   (user-need (category age) (value "new"))
   (user-need (category maintenance) (value "low"))
   =>
   (assert (car-rec 
            (model "Chery Tiggo 7 Pro")
            (type "Chinese Crossover")
            (price "1.8M - 2.3M RUB")
            (fuel "Petrol")
            (reliability 7)
            (reason "Modern features, good warranty, low price")
            (confidence 82)))
   (printout t crlf "*** RECOMMENDATION: Chery Tiggo 7 Pro ***" crlf)
)

;;; ======================================================
;;; RULE 19: Haval Jolion
;;; ======================================================
(defrule recommend-haval
   (declare (salience 82))
   (user-need (category budget) (value "medium"))
   (user-need (category purpose) (value "city"))
   (user-need (category mileage) (value "low"))
   (user-need (category fuel) (value "petrol"))
   (user-need (category transmission) (value "robot"))
   (user-need (category drive) (value "front"))
   (user-need (category passengers) (value "4-5"))
   (user-need (category cargo) (value "medium"))
   (user-need (category age) (value "new"))
   (user-need (category maintenance) (value "low"))
   =>
   (assert (car-rec 
            (model "Haval Jolion")
            (type "Chinese Compact SUV")
            (price "1.6M - 2.2M RUB")
            (fuel "Petrol")
            (reliability 7)
            (reason "New, stylish, good equipment")
            (confidence 84)))
   (printout t crlf "*** RECOMMENDATION: Haval Jolion ***" crlf)
)

;;; ======================================================
;;; RULE 20: Geely Coolray
;;; ======================================================
(defrule recommend-geely
   (declare (salience 81))
   (user-need (category budget) (value "medium"))
   (user-need (category purpose) (value "city"))
   (user-need (category mileage) (value "low"))
   (user-need (category fuel) (value "petrol"))
   (user-need (category transmission) (value "robot"))
   (user-need (category drive) (value "front"))
   (user-need (category passengers) (value "4-5"))
   (user-need (category cargo) (value "small"))
   (user-need (category age) (value "new"))
   (user-need (category maintenance) (value "medium"))
   =>
   (assert (car-rec 
            (model "Geely Coolray")
            (type "Chinese Crossover")
            (price "1.5M - 2M RUB")
            (fuel "Petrol")
            (reliability 7)
            (reason "Turbo engine, sporty design")
            (confidence 83)))
   (printout t crlf "*** RECOMMENDATION: Geely Coolray ***" crlf)
)

;;; ======================================================
;;; RULE 21: Porsche Cayenne
;;; ======================================================
(defrule recommend-cayenne
   (declare (salience 78))
   (user-need (category budget) (value "premium"))
   (user-need (category purpose) (value "highway"))
   (user-need (category mileage) (value "low"))
   (user-need (category fuel) (value "petrol"))
   (user-need (category transmission) (value "automatic"))
   (user-need (category drive) (value "4wd"))
   (user-need (category passengers) (value "4-5"))
   (user-need (category cargo) (value "medium"))
   (user-need (category age) (value "new"))
   (user-need (category maintenance) (value "high"))
   =>
   (assert (car-rec 
            (model "Porsche Cayenne")
            (type "Luxury SUV")
            (price "8M - 12M RUB")
            (fuel "Petrol")
            (reliability 8)
            (reason "Ultimate luxury, performance, status")
            (confidence 90)))
   (printout t crlf "*** RECOMMENDATION: Porsche Cayenne ***" crlf)
)

;;; ======================================================
;;; RULE 22: Lexus RX
;;; ======================================================
(defrule recommend-lexus
   (declare (salience 82))
   (user-need (category budget) (value "premium"))
   (user-need (category purpose) (value "family"))
   (user-need (category mileage) (value "low"))
   (user-need (category fuel) (value "hybrid"))
   (user-need (category transmission) (value "automatic"))
   (user-need (category drive) (value "4wd"))
   (user-need (category passengers) (value "4-5"))
   (user-need (category cargo) (value "medium"))
   (user-need (category age) (value "young"))
   (user-need (category maintenance) (value "high"))
   =>
   (assert (car-rec 
            (model "Lexus RX")
            (type "Luxury Crossover")
            (price "5M - 8M RUB")
            (fuel "Hybrid")
            (reliability 10)
            (reason "Premium quality, legendary reliability")
            (confidence 92)))
   (printout t crlf "*** RECOMMENDATION: Lexus RX ***" crlf)
)

;;; ======================================================
;;; RULE 23: Lada Niva Travel
;;; ======================================================
(defrule recommend-niva
   (declare (salience 83))
   (user-need (category budget) (value "low"))
   (user-need (category purpose) (value "offroad"))
   (user-need (category mileage) (value "low"))
   (user-need (category fuel) (value "petrol"))
   (user-need (category transmission) (value "manual"))
   (user-need (category drive) (value "4wd"))
   (user-need (category passengers) (value "2-3"))
   (user-need (category cargo) (value "small"))
   (user-need (category age) (value "new"))
   (user-need (category maintenance) (value "low"))
   =>
   (assert (car-rec 
            (model "Lada Niva Travel")
            (type "Compact Off-roader")
            (price "800k - 1.1M RUB")
            (fuel "Petrol")
            (reliability 6)
            (reason "Real off-road capability, cheap to buy")
            (confidence 88)))
   (printout t crlf "*** RECOMMENDATION: Lada Niva Travel ***" crlf)
)

;;; ======================================================
;;; RULE 24: BMW X5
;;; ======================================================
(defrule recommend-bmw-x5
   (declare (salience 80))
   (user-need (category budget) (value "premium"))
   (user-need (category purpose) (value "family"))
   (user-need (category mileage) (value "medium"))
   (user-need (category fuel) (value "diesel"))
   (user-need (category transmission) (value "automatic"))
   (user-need (category drive) (value "4wd"))
   (user-need (category passengers) (value "4-5"))
   (user-need (category cargo) (value "large"))
   (user-need (category age) (value "young"))
   (user-need (category maintenance) (value "high"))
   =>
   (assert (car-rec 
            (model "BMW X5")
            (type "Luxury SUV")
            (price "6M - 10M RUB")
            (fuel "Diesel")
            (reliability 8)
            (reason "Sporty handling, luxurious interior")
            (confidence 88)))
   (printout t crlf "*** RECOMMENDATION: BMW X5 ***" crlf)
)

;;; ======================================================
;;; RULE 25: Mercedes GLE
;;; ======================================================
(defrule recommend-gle
   (declare (salience 80))
   (user-need (category budget) (value "premium"))
   (user-need (category purpose) (value "highway"))
   (user-need (category mileage) (value "high"))
   (user-need (category fuel) (value "diesel"))
   (user-need (category transmission) (value "automatic"))
   (user-need (category drive) (value "4wd"))
   (user-need (category passengers) (value "4-5"))
   (user-need (category cargo) (value "large"))
   (user-need (category age) (value "new"))
   (user-need (category maintenance) (value "high"))
   =>
   (assert (car-rec 
            (model "Mercedes GLE")
            (type "Luxury SUV")
            (price "7M - 12M RUB")
            (fuel "Diesel")
            (reliability 8)
            (reason "Comfort, prestige, advanced technology")
            (confidence 89)))
   (printout t crlf "*** RECOMMENDATION: Mercedes GLE ***" crlf)
)

;;; ======================================================
;;; RULE 26: Audi Q5
;;; ======================================================
(defrule recommend-q5
   (declare (salience 83))
   (user-need (category budget) (value "high"))
   (user-need (category purpose) (value "family"))
   (user-need (category mileage) (value "medium"))
   (user-need (category fuel) (value "petrol"))
   (user-need (category transmission) (value "automatic"))
   (user-need (category drive) (value "4wd"))
   (user-need (category passengers) (value "4-5"))
   (user-need (category cargo) (value "medium"))
   (user-need (category age) (value "young"))
   (user-need (category maintenance) (value "medium"))
   =>
   (assert (car-rec 
            (model "Audi Q5")
            (type "German Crossover")
            (price "3.5M - 5.5M RUB")
            (fuel "Petrol")
            (reliability 8)
            (reason "Quattro 4WD, comfortable, modern")
            (confidence 87)))
   (printout t crlf "*** RECOMMENDATION: Audi Q5 ***" crlf)
)

;;; ======================================================
;;; RULE 27: Volvo XC60
;;; ======================================================
(defrule recommend-xc60
   (declare (salience 84))
   (user-need (category budget) (value "high"))
   (user-need (category purpose) (value "family"))
   (user-need (category mileage) (value "low"))
   (user-need (category fuel) (value "petrol"))
   (user-need (category transmission) (value "automatic"))
   (user-need (category drive) (value "4wd"))
   (user-need (category passengers) (value "4-5"))
   (user-need (category cargo) (value "medium"))
   (user-need (category age) (value "new"))
   (user-need (category maintenance) (value "high"))
   =>
   (assert (car-rec 
            (model "Volvo XC60")
            (type "Swedish Crossover")
            (price "3.8M - 5.5M RUB")
            (fuel "Petrol")
            (reliability 9)
            (reason "Safety first, comfortable, stylish design")
            (confidence 88)))
   (printout t crlf "*** RECOMMENDATION: Volvo XC60 ***" crlf)
)

;;; ======================================================
;;; RULE 28: Subaru Forester
;;; ======================================================
(defrule recommend-forester
   (declare (salience 85))
   (user-need (category budget) (value "high"))
   (user-need (category purpose) (value "offroad"))
   (user-need (category mileage) (value "medium"))
   (user-need (category fuel) (value "petrol"))
   (user-need (category transmission) (value "cvt"))
   (user-need (category drive) (value "4wd"))
   (user-need (category passengers) (value "4-5"))
   (user-need (category cargo) (value "large"))
   (user-need (category age) (value "young"))
   (user-need (category maintenance) (value "medium"))
   =>
   (assert (car-rec 
            (model "Subaru Forester")
            (type "AWD Crossover")
            (price "2.5M - 3.5M RUB")
            (fuel "Petrol")
            (reliability 9)
            (reason "Symmetrical AWD, boxer engine, excellent off-road")
            (confidence 89)))
   (printout t crlf "*** RECOMMENDATION: Subaru Forester ***" crlf)
)

;;; ======================================================
;;; RULE 29: KIA Sportage
;;; ======================================================
(defrule recommend-sportage
   (declare (salience 86))
   (user-need (category budget) (value "medium"))
   (user-need (category purpose) (value "family"))
   (user-need (category mileage) (value "medium"))
   (user-need (category fuel) (value "petrol"))
   (user-need (category transmission) (value "automatic"))
   (user-need (category drive) (value "front"))
   (user-need (category passengers) (value "4-5"))
   (user-need (category cargo) (value "medium"))
   (user-need (category age) (value "new"))
   (user-need (category maintenance) (value "medium"))
   =>
   (assert (car-rec 
            (model "KIA Sportage")
            (type "Crossover")
            (price "2M - 3M RUB")
            (fuel "Petrol")
            (reliability 8)
            (reason "Stylish design, good warranty, comfortable")
            (confidence 86)))
   (printout t crlf "*** RECOMMENDATION: KIA Sportage ***" crlf)
)

;;; ======================================================
;;; RULE 30: Renault Duster
;;; ======================================================
(defrule recommend-duster
   (declare (salience 84))
   (user-need (category budget) (value "low"))
   (user-need (category purpose) (value "offroad"))
   (user-need (category mileage) (value "medium"))
   (user-need (category fuel) (value "petrol"))
   (user-need (category transmission) (value "manual"))
   (user-need (category drive) (value "4wd"))
   (user-need (category passengers) (value "4-5"))
   (user-need (category cargo) (value "large"))
   (user-need (category age) (value "mid"))
   (user-need (category maintenance) (value "low"))
   =>
   (assert (car-rec 
            (model "Renault Duster")
            (type "Budget SUV")
            (price "1M - 1.5M RUB")
            (fuel "Petrol")
            (reliability 7)
            (reason "Affordable 4WD, simple mechanics, good off-road")
            (confidence 87)))
   (printout t crlf "*** RECOMMENDATION: Renault Duster ***" crlf)
)

;;; ======================================================
;;; DEFAULT RULE (если ни одно правило не подошло)
;;; ======================================================
(defrule default-recommendation
   (declare (salience 1))
   (user-need (category budget) (value ?b))
   (user-need (category purpose) (value ?p))
   (not (car-rec))
   =>
   (assert (car-rec 
            (model "Toyota Corolla")
            (type "Sedan")
            (price "1.5M - 2.5M RUB")
            (fuel "Petrol")
            (reliability 9)
            (reason "Reliable all-rounder for any use")
            (confidence 70)))
   (printout t crlf "*** DEFAULT RECOMMENDATION: Toyota Corolla ***" crlf)
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
