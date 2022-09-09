;models situation where one drone makes multiple trips for deliveries and returns
(define   
    (problem full_circuit)
    (:domain dronedelivery)

    (:objects 
        drone_a - drone
        location_a location_b location_c location_d - location
        parcel_a parcel_b parcel_c - parcel
        storm_a - storm
    )
    (:init
        (can-land location_a)
        (can-land location_b)
        (can-land location_c)
        (can-land location_d)
        
        (clear-skies location_a)
        (clear-skies location_b)
        (clear-skies location_c)
        (clear-skies location_d)


        (at parcel_a location_a)
        (at parcel_b location_a)
        (at parcel_c location_d)
        
        (belongs-to parcel_a location_b)
        (belongs-to parcel_b location_c)
        (belongs-to parcel_c location_a)


        (drone-at drone_a location_a)

        
        (drone-landed drone_a)

        (drone-empty drone_a)

        ;battery level of droness
        (= (battery-level drone_a) 150) 

        ;battery needed for travel
        (= (battery-needed location_a location_b) 10) 
        (= (battery-needed location_a location_c) 20) 
        (= (battery-needed location_a location_d) 15)
        (= (battery-needed location_b location_a) 10)
        (= (battery-needed location_b location_c) 12) 
        (= (battery-needed location_b location_d) 8)
        (= (battery-needed location_c location_a) 20)
        (= (battery-needed location_c location_b) 12) 
        (= (battery-needed location_c location_d) 12)
        (= (battery-needed location_d location_a) 15)
        (= (battery-needed location_d location_b) 8) 
        (= (battery-needed location_d location_c) 12)
        ;init total battery used
        (= (total-battery-used drone_a) 0)



    )
    (:goal (and
            (at parcel_a location_b)
            (at parcel_b location_c)
            (at parcel_c location_a)
            (drone-at drone_a location_a)
        )
    )
    (:metric minimize (total-battery-used))
)
