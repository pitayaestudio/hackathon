//
//  SignInVC.swift
//  Pitayapop
//
//  Created by Brenda Saavedra on 6/22/17.
//  Copyright © 2017 Pitaya Estudio. All rights reserved.
//

import UIKit

class SignInVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var tfEmail: FancyField!
    @IBOutlet weak var tfPass: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: Keyboard
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextfield(textField, moveDistance: -100, up: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextfield(textField, moveDistance: -100, up: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func moveTextfield(_ textfield:UITextField, moveDistance: Int, up: Bool){
        let moveDuration = 0.3
        let movement:CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField",context:nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx:0,dy:movement)
        UIView.commitAnimations()
        
    }
    
    //MARK: IBAction
    @IBAction func signInBtnPressed(_ sender: AnyObject) {
        if let email = tfEmail.text, let pass = tfPass.text , (email.characters.count > 0 && pass.characters.count > 0){
            AuthService.instance.loginWithEmail(email, password: pass, onComplete: { (errMsg, data) in
                if errMsg == nil {
                    self.performSegue(withIdentifier: SEGUE_FEEDVC, sender: nil)
                }else{
                    let alert = UIAlertController(title: "Error Authentication", message: errMsg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated:true, completion:nil)
                }
            })
        }else{
            let alert = UIAlertController(title: "Username and Password required", message: "You must enter both a username and a password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }


}

