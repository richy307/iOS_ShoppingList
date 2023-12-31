//
//  ShoppingTableViewController.swift
//  iOS_ShoppingList
//
//  Created by 王麒翔 on 2023/7/30.
//

import UIKit

typealias AddItemClosure = (Bool, String?)->()

class ShoppingTableViewController: UITableViewController {
    
    // Add Button
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        popUpAlertWithDefault(nil) {
            (success:Bool, result:String?) in
            if success == true {
                if let okResult = result {
                    self.shoppingItems.append(okResult) // 在closure內要加上self.
                    
                    // tableView.reloadData() // 重新讀取data // 每個 cell 都會重新產生
                    let insertInfoAtThisIndexPath = IndexPath(row: self.shoppingItems.count-1, section: 0)
                    self.tableView.insertRows(at: [insertInfoAtThisIndexPath], with: .automatic) // 插入新資料
                    self.saveList()
                }
            }
        }
        
        // let newItem = "Apple Watch"
        // shoppingItems.append(newItem)
    }
    
    // Alert Controller
    func popUpAlertWithDefault(_ defaultValue:String?, withCompletionHandler handler: @escaping AddItemClosure) {
        
        // Alert Controller
        let alert = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .alert)
        
        // add Alert Text Field
        alert.addTextField(configurationHandler: {(textfield) in
            textfield.placeholder = "Add New Item Here"
            textfield.text = defaultValue
        })
        
        // OK Alert Action
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action) in
            // what to do after pressing ok button
            // take out text from textfield // 取input值
            if let inputText = alert.textFields?[0].text {
                if inputText != "" {
                    // ... append inputText to shopping list
                    handler(true, inputText)
                } else {
                    handler(false, nil)
                }
            }
        })
        
        // Cancel Alert Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action) in
            handler(false, nil)
        })
        
        // add Alert Action
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        // show Alert Controller
        present(alert, animated: true, completion: nil)
    }
    
    // UserDefaults set
    func saveList() {
        UserDefaults.standard.set(shoppingItems, forKey: "list")
    }
    
    // UserDefaults get
    func loadList() {
        if let okList = UserDefaults.standard.stringArray(forKey: "list") {
            shoppingItems = okList
        }
    }
    
    // UITableView Accessory Button (Edit)
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        popUpAlertWithDefault(shoppingItems[indexPath.row]) {
            (success:Bool, result:String?) in
            if success == true {
                if let okResult = result {
                    // shoppingItems.append(okResult)
                    self.shoppingItems[indexPath.row] = okResult
                    tableView.reloadData() // 重新讀取data // 每個 cell 都會重新產生
                    self.saveList()
                }
            }
        }
    }
    
    // UITableViewCell EditingStyle (Left Swipe...) (Delete)
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shoppingItems.remove(at: indexPath.row)
            saveList()
            tableView.reloadData()
        }
    }
    
    // Array Data
    var shoppingItems = [String]() // init empty array // ["iPhone", "iPad", "iMac"]

    override func viewDidLoad() {
        super.viewDidLoad()
        loadList()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shoppingItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = shoppingItems[indexPath.row]

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
