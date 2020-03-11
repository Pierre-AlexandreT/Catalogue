//
//  ViewController.swift
//  catalogue
//
//  Created by lpiem on 11/03/2020.
//  Copyright © 2020 pat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var randomData: [String]!
    
    var items: [Item]!
    
    var sortAscend = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //let searchController = UISearchController(searchResultsController: nil)
    
    var dataManager: CoreDataManager {
        get {
            return CoreDataManager.shared
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadItems()

        // Reload the table
        tableView.reloadData()
        
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: Actions
    
    @IBAction func sortItems(_ sender: Any) {
        self.sortAscend = !self.sortAscend
        loadItems()
    }
    
    //MARK: Methods
    
    func loadItems(){
        if let items = CoreDataManager.shared.loadItems(ascend: self.sortAscend){
            self.items = items
            
            tableView.reloadData()
        }
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.items[indexPath.row].isFavorite = !self.items[indexPath.row].isFavorite

        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
        
        if item.isFavorite {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.items = dataManager.loadItems(ascend: sortAscend, name: searchText)
        tableView.reloadData()
    }
}

extension ViewController: SegueHandlerType{
    
    enum SegueIdentifier: String {
        case goFilter
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .goFilter:
            let nextScreen = segue.destination as! FilterController
            nextScreen.delegate = self
        }
    }

    
}

extension ViewController: FilterControllerDelegate {
    func onDone(price: Double) {
        items = dataManager.loadItems(ascend: sortAscend, price: price)
        tableView.reloadData()
    }
    
    
}


