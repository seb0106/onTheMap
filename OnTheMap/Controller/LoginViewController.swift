//*
// * Copyright (C) Schweizerische Bundesbahnen SBB, 2020.
//*

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginButton.layer.cornerRadius = 5
    }
    
    func handleGetStudentLocation(success: StudentLocation, error: Error?) {
        if !success.results.isEmpty {
            print(success)
        } else {
            print(error ?? "")
        }
    }
    
    func handleLogin(success: Bool, error: Error?){
        if success{
            performSegue(withIdentifier: "completeLogin", sender: nil)
            emailText.text = ""
            passwordText.text = ""
        } else {
            let alert = UIAlertController(title: "Login didn't work", message: "Maybe your Password or email is incorrect.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            print(error!)
        }
    }
    @IBAction func loginSession(_ sender: Any) {
        UdacityClient.login(email: emailText.text ?? "", password: passwordText.text ?? "",completion: handleLogin(success:error:))
    }
}


