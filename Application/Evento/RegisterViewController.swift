//
//  RegisterViewController.swift
//  
//
//  Created by Saransh Mittal on 21/07/18.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func registerAction(_ sender: Any) {
        changeControls(enable: false)
        if contactTextField.text! == "" && usernameTextField.text! == "" && nameTextField.text! == "" && passwordTextField.text! == "" && emailTextField.text! == "" {
            self.changeControls(enable: true)
            AlertView.show(title: "Please fill all the required details", message: "Fields empty!", viewController: self)
            return
        }
        
        NetworkEngine.registerUser(username: usernameTextField.text!, password: passwordTextField.text!, email: emailTextField.text!, phoneNumber: contactTextField.text!, name: nameTextField.text!) { (success) in
            self.changeControls(enable: true)
            if success {
                AlertView.show(title: "Welcome to the Evento family!", message: "Authentication Successfull", viewController: self)
            } else {
                AlertView.show(title: "Please try again!", message: "Authentication Failure", viewController: self)
            }
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func changeControls(enable: Bool) {
        if enable == true {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
        activityIndicator.isHidden = enable
        usernameTextField.isEnabled = enable
        passwordTextField.isEnabled = enable
        contactTextField.isEnabled = enable
        nameTextField.isEnabled = enable
        emailTextField.isEnabled = enable
        registerButton.isEnabled = enable
    }
    
    func dismissKeyboard() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        contactTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
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
        editTextFieldView(textField: contactTextField, color: UIColor.white)
        editTextFieldView(textField: nameTextField, color: UIColor.white)
        editTextFieldView(textField: emailTextField, color: UIColor.white)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
