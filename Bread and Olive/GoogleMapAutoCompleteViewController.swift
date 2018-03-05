//
//  ViewController.swift
//  GMapsDemo
//
//  Created by Gabriel Theodoropoulos on 29/3/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import BTNavigationDropdownMenu
import Alamofire
import SwiftyJSON
import SCLAlertView
import Material


enum TravelModes: Int {
    case driving
    case walking
    case bicycling
}


class GoogleMapAutoCompleteViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var viewMap: GMSMapView!
    
    @IBOutlet weak var lblInfo: UILabel!
    
    
    
    private var menuButton: IconButton!
    
    /// NavigationBar switch control.
    private var switchControl: MaterialSwitch!
    
    /// NavigationBar search button.
    private var searchButton: IconButton!

    
    
    var idx = -1
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var catName = ""
    
    var resturants = [mapRes]()
    /* var res:Resturants!
     var category = [Category]()
     var searchcategory = [Category]()
     var rescat = [Resturants]()
     */
    
    var id = ""
    
    var lat:Double!
    
    var long:Double!
    var mylat:Double!
    var mylong:Double!
    
    var locationManager = CLLocationManager()
    
    var didFindMyLocation = false
    
    var mapTasks = MapTasks()
    
    var locationMarker: GMSMarker!
    
    var originMarker: GMSMarker!
    
    var destinationMarker: GMSMarker!
    
    var routePolyline: GMSPolyline!
    
    var markersArray: Array<GMSMarker> = []
    
    var waypointsArray: Array<String> = []
    
    var travelMode = TravelModes.driving
    
    
    
    @IBOutlet weak var subView: UIView!
    
    
    
    
    func prepareView() {
        view.backgroundColor = MaterialColor.white
        prepareMenuButton()
        prepareNavigationItem()
        self.navigationController?.navigationBar.translucent = true
    }
    
    /// Handles the menuButton.
    internal func handleMenuButton() {
        navigationDrawerController?.openLeftView()
    }
    
    /// Handles the searchButton.
    
    /// Prepares the menuButton.
    private func prepareMenuButton() {
        let image: UIImage? = UIImage(named: "cm_menu_white")
        menuButton = IconButton()
        menuButton.pulseColor = MaterialColor.white
        menuButton.setImage(image, forState: .Normal)
        menuButton.setImage(image, forState: .Highlighted)
        menuButton.addTarget(self, action: #selector(handleMenuButton), forControlEvents: .TouchUpInside)
    }
    
    
    /// Prepares the navigationItem.
    private func prepareNavigationItem() {
        navigationItem.title = "Around me"
        navigationItem.titleLabel.textAlignment = .Left
        navigationItem.titleLabel.textColor = MaterialColor.white
        navigationItem.titleLabel.font = RobotoFont.mediumWithSize(20)
        
        navigationItem.leftControls = [menuButton]
        //   navigationItem.rightControls = [switchControl, searchButton]
    }

    
    
    
    
    
    
    
    func updateArrayMenuOptions(){
        
        
        
        
        
        let url = Settings.mainUrl + "near_by?longitude=\(self.long)&latitude=\(self.lat)"
        
        Alamofire.request(.GET, url, parameters: ["foo": "bar"])
            .responseJSON { response in
                
                switch (response.2)
                {
                case .Success:
                    
                    
                    if let value = response.2.value {
                        let json = JSON(value)
                        
                        self.resturants = mapRes.modelsFromDictionaryArray(json.rawValue as! NSArray)
                        
                        self.setOutLetsMarkers()
                        
                    }
                    break
                case .Failure:
                    
                    
                    let result = response.2.debugDescription
                    if(result.containsString("no row"))
                    {
                        
                    }
                    if(result.containsString("The Internet connection appears to be offline"))
                    {
                        
                        let appearance = SCLAlertView.SCLAppearance(
                            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                            showCloseButton: false
                        )
                        
                        let alert = SCLAlertView(appearance: appearance)
                        
                        
                        alert.showTitle(
                            "", // Title of view
                            subTitle: "check your Connection \nand try again !", // String of view
                            duration: 2.0, // Duration to show before closing automatically, default: 0.0
                            completeText: "Try again", // Optional button value, default: ""
                            style: SCLAlertViewStyle.Error, // Styles - see below.
                            colorStyle: 0xA429FF,
                            colorTextButton: 0xFFFFFF
                        )
                        
                        
                    }
                    
                }
                
        }
        
        
        
    }
    
    
    
    
    func setOutLetsMarkers(){
        var markersArray:[GMSMarker] = [GMSMarker]()
        viewMap.clear()
        
        
        for i in 0..<resturants.count {
            let out = resturants[i]
            var splat = 0.0
            var splong = 0.0
            
            if let lat = out.latitude {
                splat = Double(lat)!
            }
            
            if let long = out.longitude
            {
                splong = Double(long)!
                
            }
            
            
            if(splat != 0.0 && splong != 0.0)
            {
                
                let marker = GMSMarker(position: CLLocationCoordinate2DMake(splat, splong))
                marker.map = viewMap
                marker.icon = GMSMarker.markerImageWithColor(UIColor.purpleColor())
                
                markersArray.append(marker)
                markersArray[i].map = viewMap
                
                markersArray[i].userData = out
                
                
                markersArray[i].title = out.restaurant_name
                
                
            }
            
            
        }
     
        
    }
    
    
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
        
        
         let out = marker.userData as! mapRes
        //     self.id = out.otlId!
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc =  storyboard.instantiateViewControllerWithIdentifier("ProfileView") as! ProfileViewController
       
        vc.id = out.restaurant_id!
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "profileSegue")
        {
            //  let resVc = segue.destinationViewController as! ProfileViewController
            
            //resVc.id = self.id
        }
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(33.5138073, longitude: 36.2765279, zoom: 10.0)
        viewMap.camera = camera
        viewMap.delegate = self
        viewMap.settings.myLocationButton = true
        viewMap.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        viewMap.removeObserver(self, forKeyPath: "myLocation", context: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.prepareView()
        self.load()
        
        
      
    }
    
    
    func load(){
        
        self.configureNavigationTabBar()
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
      //  self.navigationItem.titleView = searchController?.searchBar
      //  subView.frame = (CGRectMake(0, 0, self.view.frame.width, 44.0))
        subView.addSubview((searchController?.searchBar)!)
    
        //self.view.addSubview(subView)
        self.definesPresentationContext = true
        searchController?.searchBar.autocapitalizationType = .None
        searchController?.searchBar.autocorrectionType = .No
        searchController?.searchBar.enablesReturnKeyAutomatically = true
        searchController?.hidesNavigationBarDuringPresentation = true
        
        
      //  self.navigationController?.navigationBar.backgroundColor = MaterialColor.deepOrange.base
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        self.definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        
        
    }

    
    // MARK: IBAction method implementation
    
    
    // MARK: CLLocationManagerDelegate method implementation
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedAlways {
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
        if locationMarker != nil {
            locationMarker.map = nil
        }
        
        locationMarker = GMSMarker(position: coordinate)
        locationMarker.map = viewMap
        
        locationMarker.title = mapTasks.fetchedFormattedAddress
        locationMarker.appearAnimation = kGMSMarkerAnimationPop
        locationMarker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
        locationMarker.opacity = 0.75
        
        locationMarker.flat = true
        locationMarker.snippet = snippet
    }
    
    
    func configureMapAndMarkersForRoute() {
        viewMap.camera = GMSCameraPosition.cameraWithTarget(mapTasks.originCoordinate, zoom: 9.0)
        
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
    
    
    func displayRouteInfo() {
        lblInfo.text = mapTasks.totalDistance + "\n" + mapTasks.totalDuration
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
                    self.displayRouteInfo()
                }
                else {
                    
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
            setupLocationMarker(myLocation.coordinate, snippet: "You")
            self.mylat = myLocation.coordinate.latitude
            self.mylong = myLocation.coordinate.longitude
            self.lat = self.mylat
            self.long = self.mylong
            self.updateArrayMenuOptions()
            
            didFindMyLocation = true
        }
        if (object?.finished == true )
        {
            
            object?.removeObserver(self, forKeyPath: keyPath!)
            
        }
        
        
    }
    
    
    
    
}




extension GoogleMapAutoCompleteViewController: GMSAutocompleteResultsViewControllerDelegate {
    
    
    func resultsController(resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWithPlace place: GMSPlace) {
        
        
        searchController?.active = false
        
        self.lat = place.coordinate.latitude
        self.long = place.coordinate.longitude
        
    

        
        self.updateArrayMenuOptions()
        
        let coordinate = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        self.viewMap.camera = GMSCameraPosition.cameraWithTarget(coordinate, zoom: 10.0)
        
        self.setupLocationMarker(coordinate)
    }
    
    
    
    func resultsController(resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: NSError){
        // TODO: handle the error.
        print("Error: ", error.description)
    }
    
    // Turn the network activity indicator on and off again.
    
    
    func didRequestAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    
    func didUpdateAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    
    
    private func configureNavigationTabBar() {
        //transparent background
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
        UINavigationBar.appearance().shadowImage     = UIImage()
        UINavigationBar.appearance().translucent     = true
        
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 0, height: 2)
        shadow.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSShadowAttributeName: shadow
        ]
    }
    
}
