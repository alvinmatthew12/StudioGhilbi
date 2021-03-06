//
//  FilterViewController.swift
//  StudioGhilbi
//
//  Created by Alvin Matthew Pratama on 02/04/21.
//

import UIKit

protocol FilterViewControllerDelegate {
    func didUpdateFilter(_ filters: [String: [String]]?)
}

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PickerTableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let tableContents = ["switchCell", "valueCell", "pickerCell", "pickerRangeCell"]
    var availableYears: [String] = []
    var minYearRange: Int = 0
    var maxYearRange: Int = 0
    var yearArrayAsc: [String] = []
    var yearArrayDesc: [String] = []
    
    var filterDateRange: Bool = false
    var selectedYear: String = ""
    var selectedMinYear: String = ""
    var selectedMaxYear: String = ""
    
    var yearPickerView = UIPickerView()
    var yearRangePickerView = UIPickerView()
    
    var delegate: FilterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        if selectedMinYear != "" || selectedMaxYear != "" {
            filterDateRange = true
        }
        setupYearPickerItems()
    }
    
    func setupYearPickerItems() {
        yearArrayAsc = ["-"]
        yearArrayDesc = ["-"]
        for y in stride(from: minYearRange != 0 ? minYearRange : 1980, to: maxYearRange != 0 ? maxYearRange : 2021, by: 1)  {
            yearArrayAsc.append("\(y)")
            yearArrayDesc.insert("\(y)", at: 1)
        }
        if availableYears.count < 1 {
            availableYears = yearArrayDesc
        } else {
            availableYears.insert("-", at: 0)
        }
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        var filters: [String: [String]]?
        if selectedMinYear != "" || selectedMaxYear != "" {
            filters = ["yearRange": [selectedMinYear, selectedMaxYear]]
        } else if selectedYear != "" {
            filters = ["year": [selectedYear]]
        } else {
            filters = nil
        }
        delegate?.didUpdateFilter(filters)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        resetYearFilter()
    }
    
    @objc func switchChanged(_ sender: UISwitch!) {
        filterDateRange = sender.isOn
        resetYearFilter()
    }
    
    func resetYearFilter() {
        selectedYear = ""
        selectedMinYear = ""
        selectedMaxYear = ""
        yearPickerView.selectRow(0, inComponent: 0, animated: false)
        yearRangePickerView.selectRow(0, inComponent: 0, animated: false)
        yearRangePickerView.selectRow(0, inComponent: 1, animated: false)
        let allButFirst = (self.tableView.indexPathsForVisibleRows ?? []).filter { $0.row != 0 }
        tableView.reloadRows(at: allButFirst, with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableContents[indexPath.row] == "switchCell" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchTableViewCell
            cell.label.text = "Year Range"
            cell.cellSwitch.setOn(filterDateRange, animated: true)
            cell.cellSwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
            return cell
        }
        if tableContents[indexPath.row] == "valueCell" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ValueCell", for: indexPath) as! ValueTableViewCell
            cell.label.text = filterDateRange ? "Filter by Year Range" : "Filter by Available Year"
            
            var valueText = ""
            if filterDateRange {
                if selectedMinYear != "" && selectedMaxYear != "" {
                    valueText = "\(selectedMinYear) - \(selectedMaxYear)"
                } else if selectedMinYear != "" {
                    valueText = "Min Year \(selectedMinYear)"
                } else if selectedMaxYear != "" {
                    valueText = "Max Year \(selectedMaxYear)"
                }
            } else {
                valueText = selectedYear
            }
            cell.value.text = valueText
            
            return cell
        }
        if tableContents[indexPath.row] == "pickerCell" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PickerCell", for: indexPath) as! PickerTableViewCell
            cell.delegate = self
            cell.key = "year"
            cell.components = 1
            cell.items = [availableYears]
            cell.selectedItems = [selectedYear]
            yearPickerView = cell.pickerView
            cell.pickerView.reloadAllComponents()
            return cell
        }
        if tableContents[indexPath.row] == "pickerRangeCell" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PickerCell", for: indexPath) as! PickerTableViewCell
            cell.delegate = self
            cell.key = "yearRange"
            cell.components = 2
            cell.items = [yearArrayAsc, yearArrayDesc]
            cell.selectedItems = [selectedMinYear, selectedMaxYear]
            yearRangePickerView = cell.pickerView
            cell.pickerView.reloadAllComponents()
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableContents[indexPath.row] == "pickerCell" {
            return !filterDateRange ? 140 : 0
        }
        if tableContents[indexPath.row] == "pickerRangeCell" {
            return filterDateRange ? 140 : 0
        }
        return 50
    }
    
    func didSelectItem(_ key: String, _ selectedItems: [String]) {
        if key == "yearRange" {
            let minYear = selectedItems[0]
            let maxYear = selectedItems[1]
            if  minYear != "" && maxYear != "" && maxYear < minYear {
                self.showAlert(title: "Invalid Range", message: "The minimum year must not be greater than the maximum year or vice versa.")
                return
            }
            selectedMinYear = minYear
            selectedMaxYear = maxYear
        } else if key == "year" {
            selectedYear = selectedItems[0]
        }
        let indexPath = IndexPath(row: 1, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
