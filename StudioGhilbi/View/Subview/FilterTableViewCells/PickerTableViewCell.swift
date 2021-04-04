//
//  PickerTableViewCell.swift
//  StudioGhilbi
//
//  Created by Alvin Matthew Pratama on 02/04/21.
//

import UIKit

protocol PickerTableViewCellDelegate {
    func didSelectItem(_ key: String, _ selectedItems: [String])
}

class PickerTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var delegate: PickerTableViewCellDelegate?
    var components: Int = 1
    var key: String = ""
    var items: [[String]] = []
    var selectedItems: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        DispatchQueue.main.async { [self] in
            for i in 0..<selectedItems.count {
                if let index = items[i].firstIndex(of: selectedItems[i]) {
                    pickerView.selectRow(index, inComponent: i, animated: false)
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return components
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        for i in 0..<items.count {
            return items[i].count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedItems[component] = items[component][row] != "-" ? items[component][row] : ""
        delegate?.didSelectItem(key, selectedItems)
    }
}
