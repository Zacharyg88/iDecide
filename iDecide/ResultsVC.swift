//
//  ResultsVC.swift
//  iDecide
//
//  Created by Zach Eidenberger on 10/31/17.
//  Copyright © 2017 ZacharyG. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ResultsVC: UIViewController, MKMapViewDelegate, UIWebViewDelegate {
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultMapView: MKMapView!
    @IBOutlet weak var moreInfoButton: UIButton!
    @IBOutlet weak var addFavoriteButton: UIBarButtonItem!
    @IBOutlet weak var startOverButton: UIBarButtonItem!
    @IBOutlet weak var webMenuView: UIWebView!
    @IBOutlet weak var webActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    var imageURL = String()
    var randomRestaurant = [String: AnyObject]()
    var currentPinCoordinate = CLLocationCoordinate2D()
    var restaurantAddress = String()
    let context = (UIApplication.shared.delegate as! AppDelegate).cdManager.managedObjectContext
    

   
    
    override func viewDidLoad() {

        resultLabel.adjustsFontSizeToFitWidth = true
        var randomNumber = Int()
        webActivityIndicator.isHidden = false
        webActivityIndicator.startAnimating()
        resultMapView.delegate = self
        resultMapView.camera.altitude = 2000
        webMenuView.delegate = self
        if ZomatoClient.ZomatoConstants.returnedRestaurants.count > 20 {
         randomNumber = Int(arc4random_uniform((UInt32(ZomatoClient.ZomatoConstants.returnedRestaurants.count)/3)))
        }else {
            randomNumber = Int(arc4random_uniform(UInt32(ZomatoClient.ZomatoConstants.returnedRestaurants.count)))
        }
        print(ZomatoClient.ZomatoConstants.returnedRestaurants.count)
        
        randomRestaurant = ZomatoClient.ZomatoConstants.returnedRestaurants[Int(randomNumber)]
        print(randomRestaurant)
        
        let restaurantName = randomRestaurant["name"]
        resultLabel.text = restaurantName as! String?
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Restaurant")
        let fetchPredicate = NSPredicate(format: "name = %@", restaurantName as! CVarArg)
        fetchRequest.predicate = fetchPredicate
        let alreadyFavorite = try! context.fetch(fetchRequest)
        if alreadyFavorite.count > 0 {
            self.addFavoriteButton.isEnabled = false
        }
        
        let menuURL = randomRestaurant["menu_url"]
        self.setMenu(url: menuURL as! String)
        let location = randomRestaurant["location"] as! [String: AnyObject]
        restaurantAddress = location["address"] as! String
        let latString = location["latitude"] as! String
        let lonString = location["longitude"] as! String
        let latFloat = Float(latString)
        let lonFloat = Float(lonString)
        currentPinCoordinate.latitude = CLLocationDegrees(latFloat!)
        currentPinCoordinate.longitude = CLLocationDegrees(lonFloat!)
        setupMap(lat: latFloat!, lon: lonFloat!)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webActivityIndicator.stopAnimating()
        webActivityIndicator.isHidden = true
    }
    
    @IBAction func startOver(_ sender: Any) {
        performSegue(withIdentifier: "startOver", sender: self)
    }
    
    @IBAction func goToWebPage(_ sender: Any) {
        let restaurantURL = randomRestaurant["url"]
        let app = UIApplication.shared
        app.open(URL(string: restaurantURL as! String)!, options: [String: AnyObject](), completionHandler: nil)
        
    }
    @IBAction func tryAgain(_ sender: Any) {
        addFavoriteButton.isEnabled = true
        var randomNumber = Int()
        webActivityIndicator.isHidden = false
        webActivityIndicator.startAnimating()
        resultMapView.delegate = self
        resultMapView.camera.altitude = 2000
        if ZomatoClient.ZomatoConstants.returnedRestaurants.count > 20 {
            randomNumber = Int(arc4random_uniform((UInt32(ZomatoClient.ZomatoConstants.returnedRestaurants.count)/3)))
        }else {
            randomNumber = Int(arc4random_uniform(UInt32(ZomatoClient.ZomatoConstants.returnedRestaurants.count)))
        }
        print(ZomatoClient.ZomatoConstants.returnedRestaurants.count)
        
        randomRestaurant = ZomatoClient.ZomatoConstants.returnedRestaurants[Int(randomNumber)]
        print(randomRestaurant)
        
        let restaurantName = randomRestaurant["name"]
        resultLabel.text = restaurantName as! String?
        
        let menuURL = randomRestaurant["menu_url"]
        self.setMenu(url: menuURL as! String)
        let location = randomRestaurant["location"] as! [String: AnyObject]
        let latString = location["latitude"] as! String
        let lonString = location["longitude"] as! String
        let latFloat = Float(latString)
        let lonFloat = Float(lonString)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Restaurant")
        let fetchPredicate = NSPredicate(format: "name = %@", restaurantName as! CVarArg)
        fetchRequest.predicate = fetchPredicate
        let alreadyFavorite = try! context.fetch(fetchRequest)
        if alreadyFavorite.count > 0 {
            self.addFavoriteButton.isEnabled = false
        }
        currentPinCoordinate.latitude = CLLocationDegrees(latFloat!)
        currentPinCoordinate.longitude = CLLocationDegrees(lonFloat!)
        setupMap(lat: latFloat!, lon: lonFloat!)

    }
    

    
    func setMenu(url: String) {
        let request = URLRequest(url: URL(string:url)!)
        webMenuView.loadRequest(request)
    }
    
    func setupMap(lat: Float, lon: Float) {
        resultMapView.centerCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lon))
        let pin = MKPointAnnotation()
        pin.coordinate.latitude = CLLocationDegrees(lat)
        pin.coordinate.longitude = CLLocationDegrees(lon)
        
        resultMapView.addAnnotation(pin)
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.canShowCallout = true
        let app = UIApplication.shared
        let replacedAddress = self.restaurantAddress.replacingOccurrences(of: " ", with: "+")
        let mapURL = "http://maps.apple.com/?q=\(replacedAddress))&sll=\(currentPinCoordinate.latitude),\(currentPinCoordinate.longitude)&t=s"
        print(mapURL)
        
        app.open(URL(string: mapURL)!, options: [String: AnyObject](), completionHandler: nil)
    }
    
    
    @IBAction func addFavorite(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).cdManager.managedObjectContext
        let R = randomRestaurant["R"]
        let resID = R?["res_id"] as! NSNumber
        let userRating = randomRestaurant["user_rating"]
        let location = randomRestaurant["location"]
        let latitudeString = location?["latitude"] as! String
        let latitudeFloat = Float(latitudeString)
        let longitudeString = location?["longitude"] as! String
        let longitudeFloat = Float(longitudeString)
        print(resID, latitudeFloat, longitudeFloat,randomRestaurant["photos_url"], randomRestaurant["name"], randomRestaurant["price_range"], userRating?["rating_text"], randomRestaurant["url"])
        
        
        let newFavoriteRestaurant = Restaurant.init(id: (resID.int16Value), lat: latitudeFloat!, lon: longitudeFloat!, menuURL: randomRestaurant["menu_url"] as! String, name: randomRestaurant["name"] as! String, photoURL: randomRestaurant["photos_url"] as! String, priceRange: randomRestaurant["price_range"] as! UInt16, rating: userRating?["rating_text"] as! String, url: (randomRestaurant["url"] as! String), context: context)
        
        print(newFavoriteRestaurant)
        addFavoriteButton.isEnabled = false
        
    }
    
    
}
