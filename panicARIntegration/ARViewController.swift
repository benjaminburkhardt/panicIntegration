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
    
    //counter for location checker
    var locationChecked = false
    
    
    
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
        self.arRadarView.setRadarRange(500)
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
        let rect: CGRect = CGRectMake(0.0, 0.0, 0.0, 45.0)
        
        //self.radarThumbnailPosition = PARRadarPositionBottomRight
        
        //TODO: Die Position des Radars wird nach viewDidAppear() überschireben. Dies geschieht immer nach dem das Gerät aus der faceUp Orientierung bewegt wird.
        self.arRadarView.setRadarToThumbnail(radarThumbnailPosition, withAdditionalOffset: rect)
        self.arRadarView.showRadar()
        
        ARPois.createARPoiObjects()
        
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
        
        //if person in on campus (Location of NYC, that my be spoofed with Xcode)
        //this lets us decide which POIS to show, depending on the persons location
        //in this testcase, this will remove the NYC label, when Location in NYC
        //info: benjamins home label will be covered by the UWF label - but it is there!
        
        if(newLocation.coordinate.latitude < 40.7700 && newLocation.coordinate.latitude > 40.7400 &&
            newLocation.coordinate.longitude > -73.9900 && newLocation.coordinate.longitude < -73.9700
            && locationChecked == false){
            
            locationChecked = true
            
            ARPois.createARObjectsOffCampus()
        }
        
        
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
    
    
    
    
    override func showARViewInOrientation(orientation: UIDeviceOrientation) -> Bool {
        super.showARViewInOrientation(orientation)
        return true
    }
    
    
    
    
    func updateInfoLabel() {
        var deviceAttitude: PSKDeviceAttitude = PSKSensorManager.sharedSensorManager().deviceAttitude
        var infoLabel: UILabel = infoLabels[0]
        var display: String? = nil
        
        display = String(format: "GPS signal quality: %.1d (~%.1f Meters)", String(deviceAttitude.signalQuality()), deviceAttitude.locationAccuracy())
        infoLabel.textColor = UIColor.whiteColor()
        infoLabel.text = display!.stringByAppendingFormat("\nTracking: Gyroscope (iOS 5): y:%+.4f, p:%+.4f, r:%+.4f", deviceAttitude.attitudeYaw(), deviceAttitude.attitudePitch(), deviceAttitude.attitudeRoll())
    }
    
    
    
    override func startsARAutomatically() -> Bool {
        super.startsARAutomatically()
        return true
    }
    
    //TODO: function is not called when POI is tapped!
    func arDidTapObject(object: PARObjectDelegate!) {
        print("hallo")
    }
    
}



