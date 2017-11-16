//
//  startPageViewController.swift
//  iDecide
//
//  Created by Zach Eidenberger on 11/3/17.
//  Copyright © 2017 ZacharyG. All rights reserved.
//

import UIKit
import CoreLocation

class startPageViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var iDecideButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.delegate = self
        getUserLocation()
    }
    
    @IBAction func showQuestionsVC(_ sender: Any) {
        let alert = UIAlertController(title: "What Do You Think?", message: "Would you like to input some parameters or are you feeling lucky? Well, do ya, punk?", preferredStyle: .actionSheet)
        let luckyAction = UIAlertAction(title: "Suprise Me!", style: .default, handler: { action in
            ZomatoClient.ZomatoConstants.parametersBool = false
            ZomatoClient.sharedInstance().getResturantsFromParameters { (success, errorString) in
                if success != true {
                    print(errorString)
                }
            }
            self.performSegue(withIdentifier: "jumpToSearchPending", sender: self)
        })
        alert.addAction(luckyAction)
        let answerQuestionsAction = UIAlertAction(title: "Not Today, Pal", style: .default, handler:{ action in
            ZomatoClient.ZomatoConstants.parametersBool = true
            self.performSegue(withIdentifier: "showQuestionsVC", sender: self)
        })
        alert.addAction(answerQuestionsAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showFavoritesVC(_ sender: Any) {
        performSegue(withIdentifier: "showFavoritesVC", sender: self)
        
    }
    
    override func viewDidLoad() {
        locationManager.delegate = self
    }
    
    func getUserLocation() {
        if CLLocationManager.locationServicesEnabled() {
            if locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) {
                locationManager.requestWhenInUseAuthorization()
            }else {
                locationManager.requestLocation()
            }
        }
        locationManager.requestLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last
        ZomatoClient.ZomatoParameterValues.latValue = (currentLocation?.coordinate.latitude)!
        ZomatoClient.ZomatoParameterValues.lonValue = (currentLocation?.coordinate.longitude)!
        print(locationManager.location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
}
