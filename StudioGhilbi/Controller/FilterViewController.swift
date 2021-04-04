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
    
    let tableContents = ["switchCell", "valueCell", "pickerCell"]
    var availableYears: [String] = []
    var minYearRange: Int = 0
    var maxYearRange: Int = 0
    var yearArrayAsc: [String] = []
    var yearArrayDesc: [String] = []
    
    var showPicker: Bool = true
    var filterDateRange: Bool = false
    var selectedYear: String = ""
    var selectedMinYear: String = ""
    var selectedMaxYear: String = ""
    
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
        }
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        var filters: [String: [String]]?
        if selectedMinYear != "" || selectedMaxYear != "" {
            filters = ["yearRange": [selectedMinYear, selectedMaxYear]]
        } else if selectedYear != "" {
            filters = ["year": [selectedYear]]
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
        tableView.reloadData()
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
            cell.label.text = "Filter by Year"
            
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
            cell.key = filterDateRange ? "yearRange" : "year"
            cell.components = filterDateRange ? 2 : 1
            cell.selectedItems = filterDateRange ? [selectedMinYear, selectedMaxYear] : [selectedYear]
            cell.items = filterDateRange ? [yearArrayAsc, yearArrayDesc] : [availableYears]
            cell.pickerView.reloadAllComponents()
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableContents[indexPath.row] == "valueCell" {
            showPicker = !showPicker
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableContents[indexPath.row] == "pickerCell" {
            return showPicker ? 140 : 0
        }
        return 50
    }
    
    func didSelectItem(_ key: String, _ selectedItems: [String]) {
        if key == "yearRange" {
            if selectedItems[0] != "-" || selectedItems[0] != "" {
                selectedMinYear = selectedItems[0]
            } else {
                selectedMinYear = ""
            }
            if selectedItems[1] != "-" || selectedItems[1] != "" {
                selectedMaxYear = selectedItems[1]
            } else {
                selectedMaxYear = ""
            }
        } else if key == "year" {
            if selectedItems[0] != "-" || selectedItems[0] != "" {
                selectedYear = selectedItems[0]
            }
        }
        tableView.reloadData()
    }
}
