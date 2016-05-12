//
//  ARViewController.swift
//  C2Go
//
//  Created by David Welsch on 25.04.16.
//  Copyright © 2016 Hochschule Reutlingen. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ARViewController: PARViewController, PARControllerDelegate {
    
    // Timer to regularly update GPS information
    var infoTimer: NSTimer? = nil
    
    var areOptionsVisible: Bool = true
    
    //Radar position
    var radarThumbnailPosition: PARRadarPosition = PARRadarPositionBottomRight
    
    //Information for debugging
    @IBOutlet var infoLabels: [UILabel]!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    override func loadView() {
        //set ApiKey before super.loadView()
        PARController.sharedARController().setApiKey("")
        super.loadView()
        
        //?Disable the debugging Labels
        for lbl in infoLabels {
            lbl.hidden = true
        }
        
        //radar apperance settings
        //self.arRadarView.setRadarRange(1500)
    }
    
    override func viewDidAppear(animated: Bool) {
        // check, if device supports AR everytime the view appears
        // if the device currently does not support AR, show standard error alerts
        PARController.deviceSupportsAR()
        
        super.viewDidAppear(animated)
        
        //update infoTimer for debugging information
        infoTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(ARViewController.updateInfoLabel), userInfo: nil, repeats: true)
        
        // setup radar
        //position
        //let rect: CGRect = CGRectMake(0.0, 0.0, 0.0, 45.0)
        self.radarThumbnailPosition = PARRadarPositionBottomLeft
        self.arRadarView.setRadarToThumbnail(radarThumbnailPosition)
        self.arRadarView.showRadar()
        
        createARPoiObjects()
        
    }
    
    override func usesCameraPreview() -> Bool {
        return true
    }
    override func fadesInCameraPreview() -> Bool {
        return false
    }
    
    override func rotatesARView() -> Bool {
        return true
    }
    
    override func didUpdateLocation(newLocation: CLLocation) {
        
        
        let l: CLLocation = newLocation
        let c: CLLocationCoordinate2D = l.coordinate
        let locationLabel: UILabel = infoLabels[1] 
        locationLabel.hidden = false
        let locationDetailsLabel: UILabel = infoLabels[2] 
        locationDetailsLabel.hidden = false
        locationLabel.text = String(format: "%.4f° %.4f° %.2fm", c.latitude, c.longitude, l.altitude)
        locationDetailsLabel.text = String(format: "±%.2fm ±%.2fm", l.horizontalAccuracy, l.verticalAccuracy)
        locationLabel.textColor = UIColor.whiteColor()
        locationDetailsLabel.textColor = UIColor.whiteColor()
        super.didUpdateLocation(newLocation)
    }
    
    override func didUpdateHeading(newHeading: CLHeading) {
        super.didUpdateHeading(newHeading)
        
        //infolaabels for debugging
        let headingLabel: UILabel = infoLabels[3] 
        headingLabel.hidden = false
        let headingDetailsLabel: UILabel = infoLabels[4]
        headingDetailsLabel.hidden = false
        
        headingLabel.text = String(format: "%.2f°", newHeading.trueHeading)
        headingLabel.textColor = UIColor.whiteColor()
        headingDetailsLabel.text = String(format: "±%.2f", self.deviceAttitude().headingAccuracy())
    }
    
    
    
    
    
    
    // Define, what happens if you hold the device horizontally, with the face upwards
    override func switchFaceUp(inFaceUp: Bool) {
        super.switchFaceUp(inFaceUp)
    }
    
    
    func createARPoiObjects() {
        // first clear old objects
        PARController.sharedARController().clearObjects()
       
        
        //--label creation--
        //Create location
        let nearDavidsHome = CLLocation(latitude: 48.506856, longitude: 9.182793)
        let nearBenjaminsHome = CLLocation(latitude: 30.536485, longitude: -87.219200)
        let uwfLocation = CLLocation(latitude: 30.549012, longitude: -87.218514)
        let newYorkLocation = CLLocation(latitude: 40.706597, longitude: -74.011312)
        
        //Create POILabel
        let nearDavidsHomeLabel = PARPoiLabel(title: "@Davids home", theDescription: "near the home", atLocation: nearDavidsHome)
        let nearBenjaminsHomeLabel = PARPoiLabel(title: "@Benjamins home", theDescription: "near the home", atLocation: nearBenjaminsHome)
        let uwfLabel = PARPoiLabel(title: "UWF", theDescription: "University of West Florida", theImage:UIImage(named:"UWF-logo.png"), fromTemplateXib:"PoiLabelWithImage" , atLocation: uwfLocation)
        let newYorkLabel = PARPoiLabel(title: "New York", theDescription: "The Big Apple", theImage:UIImage(named:"New_York_logo.png"), fromTemplateXib:"rtPoiLabel" , atLocation: newYorkLocation)
        
        
        //Add label to ViewController
        PARController.sharedARController().addObject(nearDavidsHomeLabel)
        PARController.sharedARController().addObject(nearBenjaminsHomeLabel)
        PARController.sharedARController().addObject(uwfLabel)
        PARController.sharedARController().addObject(newYorkLabel)
        
        //print the created POIs
        NSLog("Number of PAR Objects in SharedController: %d", PARController.sharedARController().numberOfObjects())
        
        
    }
    
    override func showARViewInOrientation(orientation: UIDeviceOrientation) -> Bool {
        return true
    }
    
    
    func updateInfoLabel() {
        var deviceAttitude: PSKDeviceAttitude = PSKSensorManager.sharedSensorManager().deviceAttitude
        
        //    let deviceAttitude: PSKDeviceAttitude = PSKDeviceAttitude.init() //l.coordinate
        
        
        var infoLabel: UILabel = infoLabels[0] as! UILabel
        var display: String? = nil
        if !deviceAttitude.hasLocation() {
            infoLabel.textColor = UIColor.redColor()
            display = "could not retrieve location"
        }
        else {
            display = String(format: "GPS signal quality: %.1d (~%.1f Meters)", String(deviceAttitude.signalQuality()), deviceAttitude.locationAccuracy())
            infoLabel.textColor = UIColor.whiteColor()
        }
        infoLabel.text = display!.stringByAppendingFormat("\nTracking: Gyroscope (iOS 5): y:%+.4f, p:%+.4f, r:%+.4f", deviceAttitude.attitudeYaw(), deviceAttitude.attitudePitch(), deviceAttitude.attitudeRoll())
    }
    
    
    
    override func startsARAutomatically() -> Bool {
        return true
    }
    
    
    func arDidTapObject(object: PARObjectDelegate!) {
        _ = 1
    }
    
}



