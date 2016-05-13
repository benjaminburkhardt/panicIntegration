//
//  ARPoiLabel.swift
//  panicARIntegration
//
//  Created by Benni on 12.05.16.
//  Copyright © 2016 Benni. All rights reserved.
//

import Foundation

class ARPoiLabel: PARPoiLabel {
    
    //stores the altitude of the poi anb my be adjusted by directly accessing this property
    var theAltitude: Float = 0.0
    
    // turn off auto-layout and stacking
    override func stacksInView() -> Bool {
        return false
    }
    // calculate the altitude of the label on screen
    
    override func updateLocation() {
        
        // super will calculate label position
        super.updateLocation()
        
        //adding the altitude correctly
        // add height above sea level to displayed content
        worldPosition().memory.z = -(theAltitude - PSKSensorManager.sharedSensorManager().deviceAttitude.locationAltitude())
        
        
        
    }
    
    
    override func updateContent() {
        //override the Description whith a distance to object 
        //my be removed
        
        super.updateContent()
        var distance: Float = floorf(self.distanceToUser() / LARGE_DISTANCE_INTERVAL)
        //PARPoiLabel.description = String(format: "%1.f km at %.1f m", distance, theAltitude)
       // self.labelTemplate.distance.text = distance
    }
}