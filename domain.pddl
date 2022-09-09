(define
    (domain dronedelivery)
    (:requirements :strips :typing :fluents) ;:negative-preconditions)
    (:types
        location parcel storm drone ; our types
    )

    ;fluents
    (:functions
        (battery-level ?b - drone)
        (battery-needed ?l1 ?l2 - location)
        (total-battery-used ?b - drone)

        
    )

    (:predicates
        ;(drone-at ?a - location)
        (drone-at ?a - drone ?b - location) ;the drone is in a location
         (storm-at ?b - location) ;the storm is in a location
        (clear-skies ?b - location) ;no storm is in a location
        (at ?d - parcel ?b - location) ;the parcel is in a location
        (has-parcel ?d - parcel ?a - drone) ; the parcel is on a drone
        (can-land ?b - location);the location is clear for landing
        (drone-is-flying ?a - drone) ;a drone is flying
        (drone-landed ?d - drone) ; drone has landed
        (belongs-to ?p - parcel ?l - location) ;parcel belongs to this address
        (drone-empty ?d - drone) ;drone cargo hold is empty

    )
    ;move the drone to a new location. right now it can teleport
    (:action change_location
        :parameters (?droneinit - drone ?locationinit - location ?locationfinal - location )
        :precondition (and
            (>= (battery-level ?droneinit) 1)
            (drone-is-flying ?droneinit)
            (drone-at ?droneinit ?locationinit)
            (clear-skies ?locationfinal)
            (>= (battery-level ?droneinit) (battery-needed ?locationinit ?locationfinal))
        )
        :effect (and
            (drone-at ?droneinit ?locationfinal)
            (not (drone-at ?droneinit ?locationinit))
            (decrease (battery-level ?droneinit) (battery-needed ?locationinit ?locationfinal))
            (increase (total-battery-used ?droneinit) (battery-needed ?locationinit ?locationfinal))
        )
    )

    (:action land
        :parameters (?drone - drone ?l - location)
        :precondition (and 
            (can-land ?l)
            (drone-is-flying ?drone)
            (drone-at ?drone ?l)
            (>= (battery-level ?drone) 1)
        )
        :effect (and 
            (not (drone-is-flying ?drone))
            (drone-landed ?drone)
            (decrease (battery-level ?drone) 1)
            (increase (total-battery-used ?drone) 1)

        )
    )

    (:action release
        :parameters (?drone - drone ?p - parcel ?l - location)
        :precondition (and 
        (drone-at ?drone ?l)
        (has-parcel ?p ?drone)
        (drone-landed ?drone)
        (belongs-to ?p ?l)
        )
        :effect (and 
        (at ?p ?l)
        (not (has-parcel ?p ?drone))
        (drone-empty ?drone)
        )
    )

    (:action parachute
        :parameters (?drone - drone ?p - parcel ?l - location)
        :precondition (and 
        (drone-at ?drone ?l)
        (has-parcel ?p ?drone)
        (drone-is-flying ?drone)
        (belongs-to ?p ?l)
        )
        :effect (and 
        (at ?p ?l)
        (not (has-parcel ?p ?drone))
        (drone-empty ?drone)
        )
    )

    
    (:action pickup
        :parameters (?drone - drone ?p - parcel ?l - location)
        :precondition (and 
        (drone-at ?drone ?l)
        (drone-landed ?drone)
        (drone-empty ?drone)
        (at ?p ?l)
        )
        :effect (and 
        (has-parcel ?p ?drone)
        (not (at ?p ?l))
        (not (drone-empty ?drone))
        )
    )


    (:action take_off
        :parameters (?drone - drone ?l - location)
        :precondition (and
            (drone-at ?drone ?l)
            (drone-landed ?drone)
            (>= (battery-level ?drone) 3)
        )
        :effect (and
            (drone-is-flying ?drone)
            (not (drone-landed ?drone))
            (decrease (battery-level ?drone) 3)
            (increase (total-battery-used ?drone) 3)

        )
    )
)
