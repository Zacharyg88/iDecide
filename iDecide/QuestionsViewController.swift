//
//  QuestionsViewController.swift
//  iDecide
//
//  Created by Zach Eidenberger on 10/30/17.
//  Copyright © 2017 ZacharyG. All rights reserved.
//

import UIKit

class QuestionsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var questionImageView: UIImageView!
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var questionSlider: UISlider!
    @IBOutlet weak var sliderLabel: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var questionViewControllerView: UIView!
    @IBOutlet weak var pickOneSegmentedControl: UISegmentedControl!
    
    var userQuestionStatus = String()
    
    override func viewDidLoad() {
        userDistance()
        questionTextField.delegate = self
        questionSlider.maximumValue = 30
        sliderLabel.text = "\(questionSlider.value) Miles"
        questionSlider.addTarget(self, action: #selector(SliderDidChange(_:)), for: UIControlEvents.valueChanged)
        pickOneSegmentedControl.isHidden = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func SubmitInfo(_ sender: Any) {
        if userQuestionStatus == "Distance" {
            ZomatoClient.ZomatoParameterValues.radiusValue = Double(Int(self.questionSlider.value * 1609.34))
            userKeywordInput()
        }else if userQuestionStatus == "Keyword" {
            let keyword = questionTextField.text! as String
            if keyword.contains(" ") {
                let affectedKeyword = keyword.replacingOccurrences(of: " ", with: "_")
                ZomatoClient.ZomatoParameterValues.keywordStringValue = affectedKeyword
            }else {
                ZomatoClient.ZomatoParameterValues.keywordStringValue = questionTextField.text!
            }
            userPickOne()
        }else if userQuestionStatus == "Pick" {
            if pickOneSegmentedControl.selectedSegmentIndex == 0 {
                ZomatoClient.ZomatoParameterValues.sortValue = "Budget"
            }else if pickOneSegmentedControl.selectedSegmentIndex == 1 {
                ZomatoClient.ZomatoParameterValues.sortValue = "Rating"
            }else{
                ZomatoClient.ZomatoParameterValues.sortValue = "Distance"
            }
            userBigSpender()
        }else if userQuestionStatus == "Spender" {
            if sliderLabel.text == "$" {
                ZomatoClient.ZomatoConstants.userBudget = 1
            }else if sliderLabel.text == "$$" {
                ZomatoClient.ZomatoConstants.userBudget = 2
            }else if sliderLabel.text == "$$$" {
                ZomatoClient.ZomatoConstants.userBudget = 3
            }else if sliderLabel.text == "$$$$" {
                ZomatoClient.ZomatoConstants.userBudget = 4
            }
            hereWeGo()
        }else if userQuestionStatus == "Search" {
            performSegue(withIdentifier: "showSearchPendingVC", sender: self)
        }
    }
    func SliderDidChange(_ sender: UISlider) {
        if userQuestionStatus == "Distance" {
            sliderLabel.text = "\(sender.value.rounded()) Miles"
        }else if userQuestionStatus == "Spender" {
            if sender.value < 7.5 && sender.value > 0 {
                sliderLabel.text = "$"
            }else if sender.value < 15 && sender.value > 7.5 {
                sliderLabel.text = "$$"
            }else if sender.value < 22.5 && sender.value > 15 {
                sliderLabel.text = "$$$"
            }else if sender.value > 22.5 {
                sliderLabel.text = "$$$$"
            }
        }
    }
    func userDistance() {
        userQuestionStatus = "Distance"
        questionTextField.isHidden = true
        useSlider()
    }
    func userKeywordInput() {
        userQuestionStatus = "Keyword"
        UIView.transition(with: self.questionViewControllerView, duration: 2, options: .transitionCrossDissolve, animations: {self.self.questionImageView.image = #imageLiteral(resourceName: "Anything")
            self.questionTextField.isHidden = false
            self.hideSlider()
            self.questionTextField.becomeFirstResponder()
            
        }, completion: nil)
        
    }
    func userPickOne() {
        userQuestionStatus = "Pick"
        UIView.transition(with: self.questionViewControllerView, duration: 2, options: .transitionCrossDissolve, animations: {self.questionImageView.image = #imageLiteral(resourceName: "PickOne")
            self.questionTextField.isHidden = true
            self.pickOneSegmentedControl.isHidden = false
        }, completion: nil)
    }
    func userBigSpender() {
        userQuestionStatus = "Spender"
        UIView.transition(with: self.questionViewControllerView, duration: 2, options: .transitionCrossDissolve, animations: {self.questionImageView.image = #imageLiteral(resourceName: "Spender")
            self.questionTextField.isHidden = true
            self.questionSlider.value = 0
            self.useSlider()
            self.sliderLabel.text = ""
            self.pickOneSegmentedControl.isHidden = true
        }, completion: nil)
    }
    func hereWeGo() {
        userQuestionStatus = "Search"
        UIView.transition(with: self.questionViewControllerView, duration: 2, options: .transitionCrossDissolve, animations: {self.questionImageView.image = #imageLiteral(resourceName: "herewego")
            self.submitButton.titleLabel?.text = "Search!"
            self.hideSlider()
        }, completion: nil)

    }
    func useSlider() {
        questionSlider.isHidden = false
        sliderLabel.isHidden = false
    }
    func hideSlider() {
        questionSlider.isHidden = true
        sliderLabel.isHidden = true
    }
//    
//    func getUserLocation() {
//        if CLLocationManager.locationServicesEnabled() {
//            if locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) {
//                locationManager.requestWhenInUseAuthorization()
//            }else {
//                locationManager.requestLocation()
//            }
//        }
//        locationManager.requestLocation()
//    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let currentLocation = locations.last
//        ZomatoClient.ZomatoParameterValues.latValue = (currentLocation?.coordinate.latitude)!
//        ZomatoClient.ZomatoParameterValues.lonValue = (currentLocation?.coordinate.longitude)!
//    }
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error)
//    }
}
