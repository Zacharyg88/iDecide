//
//  searchPendingVC.swift
//  iDecide
//
//  Created by Zach Eidenberger on 10/31/17.
//  Copyright © 2017 ZacharyG. All rights reserved.
//

import UIKit

class searchPendingVC: UIViewController {
    
    @IBOutlet weak var statementsImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var imageCount = Int()
    
    override func viewDidLoad() {
        statementsImageView.image = #imageLiteral(resourceName: "MaitreD")
        cycleStatements(delay: 2)
        activityIndicator.startAnimating()
        //getUserLocation()
        searchZomato()
    }
    
    func cycleStatements(delay: Int) {
        let imageArray = [#imageLiteral(resourceName: "MaitreD"), #imageLiteral(resourceName: "poutine"),#imageLiteral(resourceName: "Digging"), #imageLiteral(resourceName: "IceCream"),#imageLiteral(resourceName: "AbeFroman"), #imageLiteral(resourceName: "BabyBack"), #imageLiteral(resourceName: "Boneless"), #imageLiteral(resourceName: "chickenNuggets"), #imageLiteral(resourceName: "CupCakes"), #imageLiteral(resourceName: "Fries"), #imageLiteral(resourceName: "spoon"), #imageLiteral(resourceName: "StreetMeat")]
        if delay > 0 {
            if imageCount < 5{
                do {
                    let randomNumber = Int(arc4random_uniform(12))
                    UIImageView.transition(with: self.statementsImageView, duration: 5, options: .transitionCrossDissolve, animations: {self.statementsImageView.image = imageArray[(randomNumber)]}, completion: nil)
                    imageCount = imageCount + 1
                    print("cycling images")
                }catch {
                    print("there was an error changing the images")
                }
                let delayInNanoSeconds = UInt64(delay) * NSEC_PER_SEC
                let time = DispatchTime.now() + Double(Int64(delayInNanoSeconds)) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: time) {
                    self.cycleStatements(delay: delay)
                }
                
            }else {
                performSegue(withIdentifier: "showResultsVC", sender: self)
                activityIndicator.stopAnimating()
            }
        }
    }
    
    func searchZomato() {
        ZomatoClient.sharedInstance().getResturantsFromParameters { (success, errorString) in
            if success != true {
                print(errorString)
            }
        }
    }
}
