//
//  FavoritesViewController.swift
//  iDecide
//
//  Created by Zach Eidenberger on 11/3/17.
//  Copyright © 2017 ZacharyG. All rights reserved.
//

import UIKit
import CoreData

class favoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var favoritesTableView: UITableView!
    
    var context = (UIApplication.shared.delegate as! AppDelegate).cdManager.managedObjectContext
    
    
    override func viewDidLoad() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Restaurant")
        let sort = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        fetchedResultsController?.delegate = self
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController = frc
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let favoriteToDelete = fetchedResultsController?.object(at: indexPath)
        print(favoriteToDelete)
        print(indexPath)
        
        if editingStyle == .delete {
            context.delete(favoriteToDelete as! Restaurant)
            favoritesTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
    }
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? {
        didSet{
            fetchedResultsController?.delegate = self
            fetchResults()
            self.favoritesTableView.reloadData()
            
        }
    }
    func fetchResults() {
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
            }catch {
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(fetchedResultsController?.fetchedObjects?.count)
        
        return (fetchedResultsController?.fetchedObjects?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritesTableView.dequeueReusableCell(withIdentifier: "cell") as! favoritesTableViewCell
        let favorite = fetchedResultsController?.object(at: indexPath) as! Restaurant
        cell.titleLabel.text = favorite.name
        cell.titleLabel.font = UIFont(name: "PoiretOne-Regular", size: 26)
        cell.subtitleLabel.text = favorite.rating
        cell.subtitleLabel.font = UIFont(name: "PoiretOne-Regular", size: 16)
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        let favorite = fetchedResultsController?.object(at: indexPath) as! Restaurant
        let replacedName = favorite.name?.replacingOccurrences(of: " ", with: "+")
        let mapURL = "http://maps.apple.com/?q=\((replacedName)!)&sll=\(favorite.lat),\(favorite.lon)&t=s"
        print(mapURL)
        
        app.open(URL(string: mapURL)!, options: [String: AnyObject](), completionHandler: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
