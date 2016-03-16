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
    @IBOutlet var accessoryBar: UINavigationBar!
    @IBOutlet weak var barDoneButton: UIBarButtonItem!
    
    @IBOutlet weak var photosCountLabel: UILabel!
    @IBOutlet weak var photoFormatTextField: UITextField!
    @IBOutlet weak var totalSumLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!

    @IBOutlet weak var payButton: UIButton!
    var order: Order!
    var activeField: UITextField?
    
    // MARK: - VC
    func updateUI(){
        photosCountLabel.text = String(order.photos.count)
        photoFormatTextField.text = order.photoFormat.description
        totalSumLabel.text = String(order.sum)
        addressTextField.text = order.address?.description
    }
    
    override func viewDidLoad() {
        self.photoFormatTextField.inputView = pickerView
        self.photoFormatTextField.inputAccessoryView = accessoryBar
        self.addressTextField.inputView = pickerView
        self.addressTextField.inputAccessoryView = accessoryBar
        
        // tap gesture recognizer for hiding keyboard
        let tapRec = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard:"))
        self.view.addGestureRecognizer(tapRec)
        
        view.backgroundColor = UI.catskillWhite
        
        payButton.backgroundColor = UI.bsGreen
        payButton.layer.cornerRadius = 5.0
        payButton.clipsToBounds = true
        payButton.setTitleColor(UI.catskillWhite, forState: .Normal)
        
        updateUI()
    }
    
    // MARK: - Text field delegate
    
    // blocking paste and keyboard input
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        activeField = textField
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
//        if let a = activeField{
//            a.resignFirstResponder()
//            activeField = nil
//        }
    }
    
    // MARK: - Photo/address format picker
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let af = activeField {
            switch af{
            case photoFormatTextField:
                return PhotoFormat.count
            case addressTextField:
                return Model.sharedInstance.addresses.count
            default: return 0
            }
        }
        else{
            return 0
        }
    
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let a=activeField {
            switch a {
            case photoFormatTextField:
                return PhotoFormat(rawValue: row)?.description
            case addressTextField:
                return Model.sharedInstance.addresses[row].description
            default: return ""
            }
        }else {
            return ""
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch activeField! {
        case photoFormatTextField: order.photoFormat = PhotoFormat(rawValue: row)!
        case addressTextField: order.address = Model.sharedInstance.addresses[row]
        default: return
        }
        order.calcPrice()
        updateUI()
    }

    
    // MARK: - Keyboard and accessory views
    
    
    @IBAction func addAddressTap(sender: UIBarButtonItem) {
        performSegueWithIdentifier("newAddress", sender: nil)
    }
    
    @IBAction func barDoneButtonTap(sender: UIBarButtonItem) {
        switch activeField! {
        case photoFormatTextField: order.photoFormat = PhotoFormat(rawValue: pickerView.selectedRowInComponent(0))!
        case addressTextField: order.address = Model.sharedInstance.addresses[pickerView.selectedRowInComponent(0)]
        default: return
        }
        
        activeField?.resignFirstResponder()
        updateUI()
        
    }
    
    func hideKeyboard(sender: UITapGestureRecognizer){
        if let a =  activeField {
            a.resignFirstResponder()
        }
    }
    
    // MARK: - Pay
    
    @IBAction func payButtonTap(sender: UIButton) {
        if let a = activeField {
            a.resignFirstResponder()
        }
        Model.sharedInstance.saveData()
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToOrder(sender: UIStoryboardSegue) {
        if let sourceVC = sender.sourceViewController as? AddressVC  {
            order.calcPrice()
            let a = sourceVC.address
                if !Model.sharedInstance.addresses.contains(a) {
                    Model.sharedInstance.addresses.append(a)
                }
                Model.sharedInstance.saveData()
            pickerView.reloadAllComponents()
        }
        
        print(sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let id = segue.identifier else {return}
        
        switch id {
        case "newAddress":
            let a = PostalAddress()
            let vc = segue.destinationViewController as! AddressVC
            vc.address = a
        case "showOrderPhotos":
            let vc = segue.destinationViewController as! OrderPhotosVC
            vc.order = order
        default: return
        }
    }
    
}
