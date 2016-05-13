//
//  ARPois.swift
//  panicARIntegration
//
//  Created by Benni on 12.05.16.
//  Copyright © 2016 Benni. All rights reserved.
//

import Foundation

class ARPois {
    
    

    
    static func createARPoiObjects() {
        // first clear old objects
        PARController.sharedARController().clearObjects()
       

        
        //--label creation--
        //Create location
        let nearDavidsHome = CLLocation(latitude: 48.506856, longitude: 9.182793)
        let nearBenjaminsHome = CLLocation(latitude: 30.538453, longitude: -87.217046)
        let uwfLocation = CLLocation(latitude: 30.549012, longitude: -87.218514)
        let newYorkLocation = CLLocation(latitude: 40.706597, longitude: -74.011312)
        
    

        
        
        //Create POILabel
        let nearDavidsHomeLabel = ARPoiLabel(title: "@Davids home", theDescription: "near the home", atLocation: nearDavidsHome)
        let nearBenjaminsHomeLabelThird = ARPoiLabel(title: "@Benjamins home", theDescription: "3rd floor", theImage:UIImage(named:"house.png"), fromTemplateXib:"benPoiLabel" , atLocation: nearBenjaminsHome)
        let nearBenjaminsHomeLabelFirst = ARPoiLabel(title: "@Benjamins home", theDescription: "1st floor", theImage:UIImage(named:"house.png"), fromTemplateXib:"benPoiLabel" , atLocation: nearBenjaminsHome)
        let uwfLabel = ARPoiLabel(title: "UWF", theDescription: "University of West Florida", theImage:UIImage(named:"UWF-logo.png"), fromTemplateXib:"PoiLabelWithImage" , atLocation: uwfLocation)
        let newYorkLabel = ARPoiLabel(title: "New York", theDescription: "The Big Apple", theImage:UIImage(named:"New_York_logo.png"), fromTemplateXib:"rtPoiLabel" , atLocation: newYorkLocation)
        
        nearBenjaminsHomeLabelFirst.theAltitude = 19.5
        nearBenjaminsHomeLabelThird.theAltitude = 29.5
        
        
        
        
        //change apearence of the point in the radar
        //TODO: image disappears, but noew image does not show up
        var imageView = UIImageView()
        var image = UIImage(named:"UWF-logo.png")
        imageView.image = image
        //nearBenjaminsHomeLabel.radarView = imageView
        
        
        //Add label to ViewController
        PARController.sharedARController().addObject(nearDavidsHomeLabel)
        PARController.sharedARController().addObject(nearBenjaminsHomeLabelFirst)
        PARController.sharedARController().addObject(nearBenjaminsHomeLabelThird)
        PARController.sharedARController().addObject(uwfLabel)
        PARController.sharedARController().addObject(newYorkLabel)
        
        //print the created POIs
        NSLog("Number of PAR Objects in SharedController: %d", PARController.sharedARController().numberOfObjects())
        
        
    }
    
    //show special POIs on campus

    static func createARObjectsOffCampus(){
        // first clear old objects
        PARController.sharedARController().clearObjects()
        
        
        //--label creation--
        //Create location
        let nearDavidsHome = CLLocation(latitude: 48.506856, longitude: 9.182793)
        let nearBenjaminsHome = CLLocation(latitude: 30.536485, longitude: -87.219200)
        let uwfLocation = CLLocation(latitude: 30.549012, longitude: -87.218514)
        //let newYorkLocation = CLLocation(latitude: 40.706597, longitude: -74.011312)
        
        //Create POILabel
        var nearDavidsHomeLabel = PARPoiLabel(title: "@Davids home", theDescription: "near the home", atLocation: nearDavidsHome)
        var nearBenjaminsHomeLabel = PARPoiLabel(title: "@Benjamins home", theDescription: "near the home", atLocation: nearBenjaminsHome)
        var uwfLabel = PARPoiLabel(title: "UWF", theDescription: "University of West Florida", theImage:UIImage(named:"UWF-logo.png"), fromTemplateXib:"PoiLabelWithImage" , atLocation: uwfLocation)
        //let newYorkLabel = PARPoiLabel(title: "New York", theDescription: "The Big Apple", theImage:UIImage(named:"New_York_logo.png"), fromTemplateXib:"rtPoiLabel" , atLocation: newYorkLocation)
        
        
        
        //change apearence of the point in the radar
        //TODO: image disappears, but noew image does not show up
        var imageView = UIImageView()
        var image = UIImage(named:"UWF-logo.png")
        imageView.image = image
        //nearBenjaminsHomeLabel.radarView = imageView
        
        
        //Add label to ViewController
        PARController.sharedARController().addObject(nearDavidsHomeLabel)
        PARController.sharedARController().addObject(nearBenjaminsHomeLabel)
        PARController.sharedARController().addObject(uwfLabel)
        //PARController.sharedARController().addObject(newYorkLabel)
        
        
        
        //print the created POIs
        NSLog("Number of PAR Objects in SharedController off campus: %d", PARController.sharedARController().numberOfObjects())
       
        
        
        
    }
    
    
    
}