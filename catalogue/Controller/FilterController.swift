//
//  FilterController.swift
//  catalogue
//
//  Created by lpiem on 11/03/2020.
//  Copyright © 2020 pat. All rights reserved.
//

import UIKit

class FilterController: UITableViewController{
    
    var delegate: FilterControllerDelegate?
    
    var maxMinItem: [Item] = []

    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var maxPrice: UILabel!
    
    @IBOutlet weak var minPrice: UILabel!
    
    var dataManager: CoreDataManager {
        get {
            return CoreDataManager.shared
        }
    }
    
    override func viewDidLoad() {
        if let item = dataManager.getMaxPriceItem(){
            maxMinItem = item
            minPrice.text = String(item[0].price)
            maxPrice.text = String(item[1].price)
        }
    }
    
    
    //MARK: -Actions
    
    @IBAction func onDone(_ sender: Any) {
        
        delegate?.onDone(price: (maxMinItem[1].price-maxMinItem[0].price) * (Double(round(100*Double(slider.value))/100)))
    }
    
}

protocol FilterControllerDelegate: class{
    func onDone(price: Double)
}
