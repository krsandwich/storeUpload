//
//  MyPickerView.swift
//  StoreUpload
//
//  Created by Kylee Krzanich on 4/26/19.
//  Copyright © 2019 Kylee Krzanich. All rights reserved.
//

import Foundation
import UIKit

class MyPickerView : UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {

    var pickerData : [String]!
    var pickerTextField : UITextField!
    
    init(pickerData: [String], dropdownField: UITextField) {
        super.init()
        
        self.pickerData = pickerData
        self.pickerTextField = dropdownField
        
        self.delegate = self
        self.dataSource = self
        
        dispatch_async(dispatch_get_main_queue(), {
            if pickerData.count &gt; 0 {
                self.pickerTextField.text = self.pickerData[0]
                self.pickerTextField.enabled = true
            } else {
                self.pickerTextField.text = nil
                self.pickerTextField.enabled = false
            }
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Sets number of columns in picker view
    func numberOfComponentsInPickerView(pickerView: UIPickerView); -&gt; Int {
    return 1
    }
    
    // Sets the number of rows in the picker view
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -&gt; Int {
    return pickerData.count
    }
    
    // This function sets the text of the picker view to the content of the "salutations" array
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -&gt; String? {
    return pickerData[row]
    }
    
    // When user selects an option, this function will set the text of the text field to reflect
    // the selected option.
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField.text = pickerData[row]
    }
    
    
}
