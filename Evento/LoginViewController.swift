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
        disableControls()
        let route = "/authenticate/user/login"
        let url = constants.baseURL + route
        Alamofire.request(url, method: .post, parameters: ["email":usernameTextField.text!, "password":passwordTextField.text!]).responseJSON{
            response in if response.result.isSuccess{
                let a = response.result.value! as! NSDictionary
                if a["success"] as! Int == 1{
                    print("Authentication Successfull")
                    token = a["token"] as! String
                    let URL = constants.baseURL + "/user/participate"
                    Alamofire.request(URL, method: .post, parameters: ["event_id":constants.event_id], headers: ["x-access-token":token]).responseJSON{
                        response in if response.result.isSuccess{
                            if let b:NSDictionary = response.result.value! as! NSDictionary{
                                if b != nil{
                                    print(b)
                                    if b["success"] as! Bool == true{
                                        isLogged = true
                                        print("User successfully registered")
                                        networkEngine.getProfile {
                                            networkEngine.getUserDetails {
                                                self.enableControls()
                                                self.closeAction(Any)
                                            }
                                        }
                                    } else if b["message"] as! String == "Already registered to this event"{
                                        isLogged = true
                                        print("User already registered")
                                        networkEngine.getProfile {
                                            networkEngine.getUserDetails {
                                                self.enableControls()
                                                self.closeAction(Any)
                                            }
                                        }
                                    } else {
                                        self.alertView()
                                        self.enableControls()
                                    }
                                } else {
                                    self.alertView()
                                    self.enableControls()
                                }
                            } else {
                                self.alertView()
                                self.enableControls()
                            }
                        } else {
                            self.alertView()
                            self.enableControls()
                        }
                    }
                } else {
                    isLogged = false
                    self.alertView()
                    self.enableControls()
                }
            } else {
                self.alertView()
                self.enableControls()
            }
        }
    }
    
    func alertView(){
        let alert = UIAlertController(title: "Authentication failed", message: "Try again!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
    func enableControls(){
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        usernameTextField.isEnabled = true
        passwordTextField.isEnabled = true
        closeButton.isEnabled = true
        registerButton.isEnabled = true
        loginButton.isEnabled = true
    }
    func disableControls(){
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        usernameTextField.isEnabled = false
        passwordTextField.isEnabled = false
        closeButton.isEnabled = false
        registerButton.isEnabled = false
        loginButton.isEnabled = false
    }
    func dismissKeyboard() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
