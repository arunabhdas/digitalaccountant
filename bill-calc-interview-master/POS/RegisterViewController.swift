//
//  RegisterViewController.swift
//  POS
//
//  Created by Tayson Nguyen on 2019-04-23.
//  Copyright © 2019 TouchBistro. All rights reserved.
//

import UIKit
import TouchFramework

class RegisterViewController: UIViewController {
    let cellIdentifier = "Cell"
    
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var orderTableView: UITableView!
    
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var discountsLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    let viewModel = RegisterViewModel()
    let touchFramework = TouchFramework.sharedInstance
    
    override func viewWillAppear(_ animated: Bool) {
        recalculateAndDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTableView.dataSource = self
        orderTableView.dataSource = self
        menuTableView.delegate = self
        orderTableView.delegate = self
    }
    
    
    @IBAction func showTaxes() {
        let vc = UINavigationController(rootViewController: TaxViewController(style: .grouped))
        // vc.modalPresentationStyle = .formSheet
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func showDiscounts() {
        let vc = UINavigationController(rootViewController: DiscountViewController(style: .grouped))
        // vc.modalPresentationStyle = .formSheet
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
        
        
        
    }
    
    func recalculateAndDisplay() {
        touchFramework.calculateAll()
        self.subtotalLabel.text = viewModel.formatter.string(from: NSNumber(value: touchFramework.getSubtotal()))
        
        self.discountsLabel.text = viewModel.formatter.string(from: NSNumber(value: touchFramework.getAmountDiscount()))
        
        self.taxLabel.text = viewModel.formatter.string(from: NSNumber(value: touchFramework.getAlcoholAndNonAlcoholTaxAmount()))
        
        self.totalLabel.text = viewModel.formatter.string(from: NSNumber(value: touchFramework.getTotalAfterDiscountAndTaxes()))
    }
    
    
}

extension RegisterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == menuTableView {
            return viewModel.menuCategoryTitle(in: section)
            
        } else if tableView == orderTableView {
            return viewModel.orderTitle(in: section)
        }
        
        fatalError()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == menuTableView {
            return viewModel.numberOfMenuCategories()
        } else if tableView == orderTableView {
            return 1
        }
        
        fatalError()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == menuTableView {
            return viewModel.numberOfMenuItems(in: section)
            
        } else if tableView == orderTableView {
            return viewModel.numberOfOrderItems(in: section)
        }
        
        fatalError()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
        
        if tableView == menuTableView {
            cell.textLabel?.text = viewModel.menuItemName(at: indexPath)
            cell.detailTextLabel?.text = viewModel.menuItemPrice(at: indexPath)
            
        } else if tableView == orderTableView {
            cell.textLabel?.text = viewModel.labelForOrderItem(at: indexPath)
            cell.detailTextLabel?.text = viewModel.orderItemPrice(at: indexPath)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == menuTableView {
            let indexPaths = [viewModel.addItemToOrder(at: indexPath)]
            orderTableView.insertRows(at: indexPaths, with: .automatic)
            // calculate bill totals
            
            let selectedItem = viewModel.menuItemPrice(at: indexPath)

            let selectedItemCategory = viewModel.menuCategoryTitle(in: indexPath.section) ?? ""
            print("--------selectedItemCategory: \(selectedItemCategory)")
        
            let selectedItemPrice = viewModel.menuItemPrice(at: indexPath)?.removeFormatAmount() ?? 0.0
            
            touchFramework.addToSubtotal(amount: selectedItemPrice)
            print("--------selectedItemPrice: \(selectedItemPrice)")
            
            if (selectedItemCategory.contains("Alcohol")) {
                touchFramework.calulateAlcoholTaxOnAlcoholSubtotal(amount: selectedItemPrice)
                print("--------alcoholSubtotal: \(touchFramework.getAlcoholSubtotal())")
                print("--------tax on Alcohol Items: \(touchFramework.getAlcoholTaxAmount())")
                
            }
            
            
            print("--------subTotal: \(touchFramework.getSubtotal())")
            recalculateAndDisplay()

            
            
        
        } else if tableView == orderTableView {
            viewModel.toggleTaxForOrderItem(at: indexPath)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView == menuTableView {
            return .none
        } else if tableView == orderTableView {
            return .delete
        }
        
        fatalError()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == orderTableView && editingStyle == .delete {
            viewModel.removeItemFromOrder(at: indexPath)
            orderTableView.deleteRows(at: [indexPath], with: .automatic)
            // calculate bill totals
            if let amount = viewModel.menuItemPrice(at: indexPath)?.removeFormatAmount() {
                let amountDouble = Double(amount)
                touchFramework.deductFromSubtotal(amount: amountDouble)
            }
            recalculateAndDisplay()
        }
    }
    
}


class RegisterViewModel {
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    var orderItems: [Item] = []
    
    func menuCategoryTitle(in section: Int) -> String? {
        return categories[section].name
    }
    
    func orderTitle(in section: Int) -> String? {
        return "Bill"
    }
    
    func numberOfMenuCategories() -> Int {
        return categories.count
    }
    
    func numberOfMenuItems(in section: Int) -> Int {
        return categories[section].items.count
    }
    
    func numberOfOrderItems(in section: Int) -> Int {
        return orderItems.count
    }
    
    func menuItemName(at indexPath: IndexPath) -> String? {
        return categories[indexPath.section].items[indexPath.row].name
    }
    
    func menuItemPrice(at indexPath: IndexPath) -> String? {
        let price = categories[indexPath.section].items[indexPath.row].price
        return formatter.string(from: price)
    }
    
    func labelForOrderItem(at indexPath: IndexPath) -> String? {
        let item = orderItems[indexPath.row]
       
        if item.isTaxExempt {
            return "\(item.name) (No Tax)"
        } else {
            return item.name
        }
    }
    
    func orderItemPrice(at indexPath: IndexPath) -> String? {
        let price = orderItems[indexPath.row].price
        return formatter.string(from: price)
    }
    
    func addItemToOrder(at indexPath: IndexPath) -> IndexPath {
        let item = categories[indexPath.section].items[indexPath.row]
        orderItems.append(item)
        return IndexPath(row: orderItems.count - 1, section: 0)
    }
    
    func removeItemFromOrder(at indexPath: IndexPath) {
        orderItems.remove(at: indexPath.row)
    }
    
    func toggleTaxForOrderItem(at indexPath: IndexPath) {
        orderItems[indexPath.row].isTaxExempt = !orderItems[indexPath.row].isTaxExempt
    }
}
