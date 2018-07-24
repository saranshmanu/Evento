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
        disableControls()
        if contactTextField.text! != "" && usernameTextField.text! != "" && nameTextField.text! != "" && passwordTextField.text! != "" && emailTextField.text! != ""{
            let route = "/authenticate/user/register"
            let url = constants.baseURL + route
            Alamofire.request(url, method: .post, parameters: ["name":nameTextField.text!, "email":emailTextField.text!, "password":passwordTextField.text!, "username":usernameTextField.text!, "contact":contactTextField.text!]).responseJSON{
                response in if response.result.isSuccess {
                    if let a:NSDictionary = response.result.value! as! NSDictionary{
                        if a["success"] as! Bool == true {
                            self.alertView(message: "Authentication Successfull", title: "Welcome to the Evento family!")
                        } else {
                            self.alertView(message: "Authentication Failure", title: "Please try again!")
                        }
                    }
                }
                self.enableControls()
            }
        } else {
            alertView(message: "Fields empty!", title: "Please fill all the required details")
        }
    }
    
    func alertView(message: String, title:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    func enableControls(){
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        usernameTextField.isEnabled = true
        passwordTextField.isEnabled = true
        contactTextField.isEnabled = true
        nameTextField.isEnabled = true
        emailTextField.isEnabled = true
        registerButton.isEnabled = true
    }
    func disableControls(){
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        usernameTextField.isEnabled = false
        passwordTextField.isEnabled = false
        contactTextField.isEnabled = false
        nameTextField.isEnabled = false
        emailTextField.isEnabled = false
        registerButton.isEnabled = false
    }
    
    func dismissKeyboard() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        contactTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
    
    func editTextFieldView(textField:UITextField, color:UIColor){
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName : color])
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
        // Dispose of any resources that can be recreated.
    }
}
