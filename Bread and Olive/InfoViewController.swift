//
//  InfoViewController.swift
//  Mawasim
//
//  Created by Nour  on 8/1/16.
//  Copyright © 2016 Nour . All rights reserved.
//

import UIKit
import SteviaLayout

import GoogleMaps
import Alamofire
import SDCAlertView
import SwiftyJSON
import Material

class InfoViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {
    
    
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var buttonView: UIView!
   // @IBOutlet weak var viewMap: GMSMapView!
    
    @IBOutlet weak var mapView: UIView!
    
    var viewMap: GMSMapView!
   // var detailsLbl = UILabel()
 //   var viewMap = UIView()
 //   var buttonView = UIView()
  //  var contentView = UIView()
    var lat = 0.0
    var long = 0.0
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
        
        on("INJECTION_BUNDLE_NOTIFICATION") {
            self.prepareView()
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
  
    @IBAction func call(sender: UIButton) {
        
        if let phone = Globals.res.phone {
            if let phoneCallURL:NSURL = NSURL(string: "tel://\(phone)") {
                let application:UIApplication = UIApplication.sharedApplication()
                //  if (!application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
                //}
            }
            
            
        }
    }
    
    func prepareView(){
        viewMap = GMSMapView()
     
        buttonView.backgroundColor = MaterialColor.clear
        phoneLbl.text = Globals.res.phone
        
        if let i = Globals.res.latitude{
        
        self.lat = Double(i)!
        
        }
        
        if let i = Globals.res.longitude{
        
        self.long = Double(i)!
        
        }
        
        self.mapView.sv(viewMap)
        self.mapView.layout(0,|viewMap|,0)
        let coordinate = CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)
       self.viewMap.camera = GMSCameraPosition.cameraWithTarget(coordinate, zoom: 12.0)
        
        self.setupLocationMarker(coordinate)
        
        
        
     
        
    }
    
    
    func viewForObserve() -> UIView{
        
        return self.contentView
    }
    
    
    var locationManager = CLLocationManager()
    
    var didFindMyLocation = false
    
    var mapTasks = MapTasks()
    
    var locationMarker: GMSMarker!
    
    var originMarker: GMSMarker!
    
    var destinationMarker: GMSMarker!
    
    var routePolyline: GMSPolyline!
    
    var markersArray: Array<GMSMarker> = []
    
    var waypointsArray: Array<String> = []
    
    var travelMode = TravelModes.walking
    
    
    var myLat:Double?
    var myLong:Double?
    var firsttime:Bool = true
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(firsttime == true){
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        myLat = locValue.latitude
        myLong = locValue.longitude
            let coordinate1 = CLLocationCoordinate2D(latitude:myLat!, longitude: self.myLong!)
            self.setupLocationMarker(coordinate1)
  addOverlayToMapView()
            

            firsttime = false
    }

}
    
    
    
    func addOverlayToMapView(){
        
        let directionURL = "https://maps.googleapis.com/maps/api/directions/json?origin=\(self.myLat!),\(self.myLong!)&destination=\(self.lat),\(self.long)&key="+Globals.serverKey
        
        Alamofire.request(.GET, directionURL, parameters: nil).responseJSON { response in
            
            switch response.2 {
                
            case .Success(let data):
                
                let json = JSON(data)

                let errornum = json["status"]
                
                
                if (errornum != "OK"){
                    
                    
                    
                }else{
                    let routes = json["routes"].array
                    
                    if routes != nil{
                        
                        let overViewPolyLine = routes![0]["overview_polyline"]["points"].string
                        if overViewPolyLine != nil{
                            
                            self.addPolyLineWithEncodedStringInMap(overViewPolyLine!)
                            
                        }
                        
                    }
                    
                    
                }
                
            case .Failure(let error):
                
                print("Request failed with error: \(error)")
                
            }
        }
        
    }
    
    func addPolyLineWithEncodedStringInMap(encodedString: String) {
        
        let path = GMSMutablePath(fromEncodedPath: encodedString)
        let polyLine = GMSPolyline(path: path)
        polyLine.strokeWidth = 5
        polyLine.strokeColor = UIColor.blueColor()
        polyLine.map = self.viewMap
        
    }
    
    
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        self.locationManager.requestAlwaysAuthorization()
        
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(33.5138073, longitude: 36.2765279, zoom: 12)
        viewMap.camera = camera
        viewMap.delegate = self
        viewMap.settings.myLocationButton = true
        viewMap.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        viewMap.removeObserver(self, forKeyPath: "myLocation", context: nil)
    }
    

    
    
    // MARK: IBAction method implementation
       // MARK: CLLocationManagerDelegate method implementation
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            viewMap.myLocationEnabled = true
        }
    }
    
    
    // MARK: Custom method implementation
    
    func showAlertWithMessage(message: String) {
        let alertController = UIAlertController(title: "GMapsDemo", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
            
        }
        
        alertController.addAction(closeAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func setupLocationMarker(coordinate: CLLocationCoordinate2D,snippet:String = "The best place on earth") {
   //     if locationMarker != nil {
     //       locationMarker.map = nil
     //   }
        
        locationMarker = GMSMarker(position: coordinate)
        locationMarker.map = viewMap
        
        locationMarker.title = mapTasks.fetchedFormattedAddress
        locationMarker.appearAnimation = kGMSMarkerAnimationPop
        locationMarker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
        locationMarker.opacity = 0.75
        
        locationMarker.flat = true
       // locationMarker.snippet = snippet
    }
    
    
    func configureMapAndMarkersForRoute() {
        viewMap.camera = GMSCameraPosition.cameraWithTarget(mapTasks.originCoordinate, zoom: 12.0)
        
        originMarker = GMSMarker(position: self.mapTasks.originCoordinate)
        originMarker.map = self.viewMap
        originMarker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
        originMarker.title = self.mapTasks.originAddress
        
        destinationMarker = GMSMarker(position: self.mapTasks.destinationCoordinate)
        destinationMarker.map = self.viewMap
        destinationMarker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
        destinationMarker.title = self.mapTasks.destinationAddress
        
        
        if waypointsArray.count > 0 {
            for waypoint in waypointsArray {
                let lat: Double = (waypoint.componentsSeparatedByString(",")[0] as NSString).doubleValue
                let lng: Double = (waypoint.componentsSeparatedByString(",")[1] as NSString).doubleValue
                
                let marker = GMSMarker(position: CLLocationCoordinate2DMake(lat, lng))
                marker.map = viewMap
                marker.icon = GMSMarker.markerImageWithColor(UIColor.purpleColor())
                
                markersArray.append(marker)
            }
        }
    }
    
    
    func drawRoute() {
        let route = mapTasks.overviewPolyline["points"] as! String
        
        let path: GMSPath = GMSPath(fromEncodedPath: route)!
        routePolyline = GMSPolyline(path: path)
        routePolyline.map = viewMap
    }
    
    
 
    
    func clearRoute() {
        originMarker.map = nil
        destinationMarker.map = nil
        routePolyline.map = nil
        
        originMarker = nil
        destinationMarker = nil
        routePolyline = nil
        
        if markersArray.count > 0 {
            for marker in markersArray {
                marker.map = nil
            }
            
            markersArray.removeAll(keepCapacity: false)
        }
    }
    
    
    
    func recreateRoute() {
        if let _ = routePolyline {
            clearRoute()
            
            mapTasks.getDirections(mapTasks.originCoordinate, destination: mapTasks.destinationCoordinate, waypoints: waypointsArray, travelMode: travelMode, completionHandler: { (status, success) -> Void in
                
                if success {
                    self.configureMapAndMarkersForRoute()
                    self.drawRoute()
               
                }
                else {
                    print(status)
                }
            })
        }
    }
    
    
    // MARK: GMSMapViewDelegate method implementation
    
    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        if let _ = routePolyline {
            let positionString = String(format: "%f", coordinate.latitude) + "," + String(format: "%f", coordinate.longitude)
            waypointsArray.append(positionString)
            
            recreateRoute()
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        //super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        if !didFindMyLocation {
            let myLocation: CLLocation = change![NSKeyValueChangeNewKey] as! CLLocation
            viewMap.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 10.0)
            viewMap.settings.myLocationButton = true
            
            didFindMyLocation = true
        }
        if (object?.finished == true )
        {
            
            object?.removeObserver(self, forKeyPath: keyPath!)
            
        }
        
        
    }
    
    
    
    
}


