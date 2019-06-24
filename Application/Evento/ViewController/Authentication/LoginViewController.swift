//
//  LoginViewController.swift
//  Evento
//
//  Created by Saransh Mittal on 21/07/18.
//  Copyright © 2018 Saransh Mittal. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBAction func loginAction(_ sender: Any) {
        self.changeControls(enable: false)
        NetworkEngine.loginUser(username: usernameTextField.text!, password: passwordTextField.text!) { (success) in
            if success {
                NetworkEngine.registerUserForEvent(completion: { (succ) in
                    if succ {
                        isLogged = true
                    } else {
                        isLogged = false
                        self.changeControls(enable: true)
                        AlertView.show(title: "Authentication failed", message: "Try again!", viewController: self)
                    }
                })
            } else {
                isLogged = false
                self.changeControls(enable: true)
                AlertView.show(title: "Authentication failed", message: "Try again!", viewController: self)
            }
        }
    }
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func changeControls(enable: Bool) {
        if enable == true {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
        activityIndicator.isHidden = enable
        usernameTextField.isEnabled = enable
        passwordTextField.isEnabled = enable
        closeButton.isEnabled = enable
        registerButton.isEnabled = enable
        loginButton.isEnabled = enable
    }
    
    @objc func dismissKeyboard() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func editTextFieldView(textField:UITextField, color:UIColor){
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : color])
        textField.layer.cornerRadius = 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard)))
        activityIndicator.isHidden = true
        editTextFieldView(textField: usernameTextField, color: UIColor.white)
        editTextFieldView(textField: passwordTextField, color: UIColor.white)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
