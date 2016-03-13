//
//  LoginViewController.swift
//  PhotoPrintUA
//
//  Created by atMamont on 30.01.16.
//  Copyright © 2016 Andrey Mamchenko. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func loginButtonPress(sender: UIButton) {
        if Model.sharedInstance.authorizeUser(emailTextField.text!, password: passwordTextField.text!, rememberMe: rememberMeSwitch.on){
            // all ok
            self.view.backgroundColor = UIColor.greenColor()
        }else{
            // shaking animation
            let animation: CAKeyframeAnimation = CAKeyframeAnimation();
            animation.keyPath = "position.x";
            animation.values = [0, 10, -10, 10, 0];
            animation.keyTimes = [0, (1 / 6.0), (3 / 6.0), (5 / 6.0), 1 ];
            animation.duration = 0.5;
            
            animation.additive = true;
            
            loginButton.layer.addAnimation(animation, forKey:"shake");
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
