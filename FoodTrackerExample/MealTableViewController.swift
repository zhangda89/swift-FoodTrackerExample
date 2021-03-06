//
//  MealTableViewController.swift
//  FoodTrackerExample
//
//  Created by durban.zhang on 2017/5/22.
//  Copyright © 2017年 durban.zhang. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {
    
    // MARK: Properties
    var meals = [MealModel]()
    
    // MARK: Actions
    @IBAction func unwindToMealList(sender: UIStoryboardSegue){
        
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row:meals.count, section:0)
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            saveMeals()
        }
        
    }
    
    
    // MARK: Private Methods
    private func loadSampleMeals(){
        let photo1 = UIImage(named:"meal1")
        let photo2 = UIImage(named:"meal2")
        let photo3 = UIImage(named:"meal3")
        
        
        guard let meal1 = MealModel(name:"Meal1", photo:photo1, rating:4) else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let meal2 = MealModel(name:"Meal2", photo:photo2, rating:5) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let meal3 = MealModel(name:"Meal3", photo:photo3, rating:3) else {
            fatalError("Unable to instantiate meal3")
        }
        
        meals += [meal1,meal2,meal3]
        
    }
    
    private func saveMeals(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: MealModel.ArchiveURL.path)
        
        if(isSuccessfulSave){
            os_log("Meals successfully saved.", log:OSLog.default, type:.debug)
        } else {
            os_log("Feiled to save meals.", log:OSLog.default, type:.error)
        }
    }
    
    private func loadMeals() -> [MealModel]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: MealModel.ArchiveURL.path) as? [MealModel]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved meals, otherwise load sample data.
        if let saveMeals = loadMeals() {
            meals += saveMeals
        } else {
            // Load the Sample Data
            loadSampleMeals()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MealTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let meal = meals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControlView.rating = meal.rating
        cell.contentView.backgroundColor = UIColor.white
        cell.backgroundColor = UIColor.white
        cell.backgroundView?.backgroundColor = UIColor.white
        cell.selectedBackgroundView?.backgroundColor = UIColor.white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath);
        cell?.contentView.backgroundColor = UIColor.white
        cell?.backgroundColor = UIColor.white
        cell?.backgroundView?.backgroundColor = UIColor.white
        cell?.selectedBackgroundView?.backgroundColor = UIColor.white

    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath);
        cell?.contentView.backgroundColor = UIColor.white
        cell?.backgroundColor = UIColor.white
        cell?.backgroundView?.backgroundColor = UIColor.white
        cell?.selectedBackgroundView?.backgroundColor = UIColor.white
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath);
        cell?.contentView.backgroundColor = UIColor.white
        cell?.backgroundColor = UIColor.white
        cell?.backgroundView?.backgroundColor = UIColor.white
        cell?.selectedBackgroundView?.backgroundColor = UIColor.white
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            saveMeals()
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier ?? "" {
        case "AddItem":
            os_log("Adding a new meal", log:OSLog.default, type:.debug)
        case "ShowDetail":
            guard let mealDetailViewcontroller = segue.destination as? MealViewController else {
                fatalError("Unexcepted destination: \(segue.destination)")
            }
            
            guard let selectMealCell = sender as? MealTableViewCell else {
                fatalError("Unexcepted sender: \(sender ?? "")")
            }
            
            guard let indexPath = tableView.indexPath(for: selectMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMeal = meals[indexPath.row]
            mealDetailViewcontroller.meal = selectedMeal
        default:
            fatalError("Unexcepted Segue Identifier: \(segue.identifier ?? "")")
        }
    }

}
