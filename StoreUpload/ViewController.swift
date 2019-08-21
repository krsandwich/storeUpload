//
//  ViewController.swift
//  StoreUpload
//
//  Created by Kylee Krzanich on 3/27/19.
//  Copyright © 2019 Kylee Krzanich. All rights reserved.
//

import UIKit

import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    var authToken: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is HomeScreen
        {
            let vc = segue.destination as? HomeScreen
            vc?.authToken = self.authToken
        }
    }
    
    @IBAction func signInTap(_ sender: Any) {
        getCredentials(username: userTextField.text ?? "", password: passTextField.text ?? "")
    }
    
    @IBAction func passwordEnter(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func usernameEnter(_ sender: Any) {
        self.passTextField.becomeFirstResponder()
    }
    
    func getCredentials(username: String, password: String) {
        let url = "https://makerstore.stanford.edu/rest/V1/integration/admin/token"
        let params = [
            "username": username,
            "password": password
        ]
        let headers = [
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            //print("STATUS CODE: \(response.response?.statusCode)")
            //self.performSegue(withIdentifier: "ShowHomeScreen", sender: self)
            switch response.response?.statusCode {
            case 200:
                // Check if not on Stanford WiFi:
                if response.result.value == nil {
                    self.handleError(message: "You must be on a Stanford University network in order to log in.")
                } else {
                    self.authToken = response.result.value as! String
                    self.performSegue(withIdentifier: "ShowHomeScreen", sender: self)
                }
            case 401:
                self.handleError(message: "Username or password is invalid.")
            default:
                self.handleError(message: "An unknown error has occurred.\nCheck your internet connection and try again.")
            }
        }
    }
    
    func handleError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {(alertAction) -> Void in
                self.passTextField.text = nil
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
