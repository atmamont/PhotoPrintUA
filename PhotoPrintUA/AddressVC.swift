//
//  AddressVC.swift
//  PhotoPrintUA
//
//  Created by atMamont on 15.03.16.
//  Copyright © 2016 Andrey Mamchenko. All rights reserved.
//

import UIKit

class AddressVC: UIViewController, UITextFieldDelegate {

    var address: PostalAddress!
    var activeField: UITextField?
    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var zipTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var streetTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    
    func updateUI(){
        firstNameTF.text = address.firstName
        lastNameTF.text = address.lastName
        zipTF.text = String(address.zip)
        countryTF.text = address.country
        cityTF.text = address.city
        streetTF.text = address.street
        phoneTF.text = address.phone
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // tap gesture recognizer for hiding keyboard
        let tapRec = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard:"))
        self.view.addGestureRecognizer(tapRec)
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - text fields
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeField = textField
    }
    
    func saveFields(){
        address.firstName = firstNameTF.text!
        address.lastName = lastNameTF.text!
        if let x = UInt(zipTF.text!){
            address.zip = x
        }
        address.country = countryTF.text!
        address.city = cityTF.text!
        address.street = streetTF.text!
        address.phone = phoneTF.text!
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwindToOrder" {
            saveFields()
        }
    }
    
    // MARK: - Keyboard and accessory views
    
    func hideKeyboard(sender: UITapGestureRecognizer){
        if let a =  activeField {
            a.resignFirstResponder()
        }
    }

}
