//
//  TaxViewController.swift
//  POS
//
//  Created by Tayson Nguyen on 2019-04-29.
//  Copyright © 2019 TouchBistro. All rights reserved.
//

import Foundation
import UIKit
import TouchFramework

class TaxViewController: UITableViewController {
    let cellIdentifier = "Cell"
    
    let viewModel = TaxViewModel()
    let touchFramework = TouchFramework.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        touchFramework.set(percentageTax: 0.0)
        title = "Taxes"
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.rightBarButtonItem = button
    }
    
    @objc func done() {
        dismiss(animated: true, completion: nil)
    }
}

extension TaxViewController {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.title(for: section)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
        
        cell.textLabel?.text = viewModel.labelForTax(at: indexPath)
        cell.accessoryType = viewModel.accessoryType(at: indexPath)
        
        let tax = taxes[indexPath.row]
        if tax.isEnabled {
            if !(tax.label.contains("Alcohol")) {
                touchFramework.addToPercentageTax(percentageTax: tax.amount)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.toggleTax(at: indexPath)
        let tax = taxes[indexPath.row]
        if tax.isEnabled {
            if !(tax.label.contains("Alcohol")) {
                print ("\(tax) was enabled")
                touchFramework.addToPercentageTax(percentageTax: tax.amount)
            } else {
                touchFramework.addToAlcoholTaxPercentage(alcoholTaxPercentage: tax.amount)
            }
        } else {
            if !(tax.label.contains("Alcohol")) {
                print ("\(tax) was disabled")
                touchFramework.deductFromPercentageTax(percentageTax: tax.amount)
            } else {
                touchFramework.deductFromAlcoholTaxPercentage(alcoholTaxPercentage: tax.amount)
            }
        }
            
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

class TaxViewModel {
    func title(for section: Int) -> String {
        return "Taxes"
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return taxes.count
    }
    
    func labelForTax(at indexPath: IndexPath) -> String {
        let tax = taxes[indexPath.row]
        return tax.label
    }
    
    func accessoryType(at indexPath: IndexPath) -> UITableViewCell.AccessoryType {
        let tax = taxes[indexPath.row]
        if tax.isEnabled {
            return .checkmark
        } else {
            return .none
        }
    }
    
    func toggleTax(at indexPath: IndexPath) {
        taxes[indexPath.row].isEnabled = !taxes[indexPath.row].isEnabled
    }
}
