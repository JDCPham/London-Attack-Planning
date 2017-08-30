(define (domain London-Attack-Domain)

	(:requirements :typing :durative-actions :numeric-fluents :equality)

	(:types 	location - object
				vehicle - object
				person - object	
				locatable - location
				casualty - person
				police-car ambulance - vehicle 
	)

	(:predicates 
			(vehicle-at ?v - vehicle ?l - location)
			(person-at ?p - person ?l - location)
			(person-in ?p - person ?v - vehicle)
			(in-treatment ?p - person ?h - locatable)
			(at ?lo - locatable ?l - location)
			(available ?v - vehicle)
			(crime-scene ?l - locatable)
			(linked ?lA ?lB - location)
			(treated ?p - person)
			(blocked ?lA ?lB - location)
	)

	(:functions 
				(travel-time ?from - location ?to - location) - number
				(space-available ?v - vehicle)
				(person-injured-severity ?p - person)
				(beds-available ?h - locatable)
	)

	(:durative-action move
	  :parameters (?v - vehicle ?from - location ?to - location)
	  :duration (= ?duration (travel-time ?from ?to))
	  :condition (and (over all (not (= ?from ?to))) (at start (vehicle-at ?v ?from))  (over all (linked ?from ?to)))
	  :effect (and (at start (not (vehicle-at ?v ?from))) (at end (vehicle-at ?v ?to)))
	)

	(:durative-action leave
	  :parameters (?v - vehicle ?lo - locatable ?l - location)
	  :duration (= ?duration 1)
	  :condition (and (over all (at ?lo ?l)) (at start (vehicle-at ?v ?lo)))
	  :effect (and (at start (not (vehicle-at ?v ?lo))) (at end (vehicle-at ?v ?l)))
	)

	(:durative-action place-person-on-vehicle
	  :parameters (?v - vehicle ?p - person ?l - location)
	  :duration (= ?duration 5)
	  :condition (and (over all (vehicle-at ?v ?l)) (at start (person-at ?p ?l)) (at start (available ?v)) (at start (>= (space-available ?v) 1)))
	  :effect (and (at start (not (person-at ?p ?l))) (at end (person-in ?p ?v)) (at start (not (available ?v))))
	)

	(:durative-action remove-person-on-vehicle
	  :parameters (?v - vehicle ?p - person ?l - location)
	  :duration (= ?duration 5)
	  :condition (and (over all (vehicle-at ?v ?l)) (at start (person-in ?p ?v)))
	  :effect (and (at start (not (person-in ?p ?v))) (at end (person-at ?p ?l)) (at end (available ?v)))
	)

	(:durative-action admit
	  :parameters (?p - person ?l - location ?h - locatable)
	  :duration (= ?duration 10)
	  :condition (and (at start (person-at ?p ?l)) (over all (at ?h ?l)) (at start (>= (beds-available ?h) 1)))
	  :effect (and (at start (not (person-at ?p ?l))) (at end (in-treatment ?p ?h)) (at start (decrease (beds-available ?h) 1)))
	)

	(:durative-action treat
	  :parameters (?p - person ?h - locatable)
	  :duration (= ?duration 100)
	  :condition (and (at start (in-treatment ?p ?h)))
	  :effect (and (at start (not (in-treatment ?p ?h))) (at end (treated ?p)) (at start (increase (beds-available ?h) 1)))
	)

	(:durative-action block
	  :parameters (?v - vehicle ?lA ?lB - location)
	  :duration (= ?duration 5)
	  :condition (and (over all (vehicle-at ?v ?lA)) (at start (linked ?lA ?lB)))
	  :effect (and (at end (not (linked ?lA ?lB))) (at end (blocked ?lA ?lB)))
	)

)

