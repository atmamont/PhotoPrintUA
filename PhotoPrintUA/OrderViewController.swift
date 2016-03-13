//
//  OrderViewController.swift
//  PhotoPrintUA
//
//  Created by atMamont on 11.03.16.
//  Copyright © 2016 Andrey Mamchenko. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet var pickerView: UIPickerView!
    
    @IBOutlet weak var photosCountLabel: UILabel!
    @IBOutlet weak var photoFormatTextField: UITextField!
    @IBOutlet weak var totalSumLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!

    var order: Order!
    var activeField: UITextField?
    
    // MARK: - VC
    func updateUI(){
        photosCountLabel.text = String(order.photos.count)
        photoFormatTextField.text = order.photoFormat.description
        totalSumLabel.text = String(order.sum)
    }
    
    override func viewDidLoad() {
        self.photoFormatTextField.inputView = pickerView
        self.addressTextField.inputView = pickerView

        // tap gesture recognizer for hiding keyboard
        let tapRec = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard:"))
        self.view.addGestureRecognizer(tapRec)
    }
    
    // MARK: - Text field delegate
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        activeField = textField
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let a = activeField{
            a.resignFirstResponder()
            activeField = nil
        }
    }
    
    // MARK: - Photo/address format picker
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch activeField! {
        case photoFormatTextField: return PhotoFormat.count
        case addressTextField: return Model.sharedInstance.addresses.count
        default: return 0
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return PhotoFormat(rawValue: row)?.description
    }
    // MARK: - Keyboard
    
    func hideKeyboard(sender: UITapGestureRecognizer){
        if let a =  activeField {
            a.resignFirstResponder()
        }
    }
}
