//*
// * Copyright (C) Schweizerische Bundesbahnen SBB, 2020.
//*

import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func logout(_ sender: Any) {
        UdacityClient.logout(completion: handleLogin(success:error:))
        self.navigationController?.popToRootViewController(animated: true)
        print("kkdkdkdk")
      //  performSegue(withIdentifier: "completeLogout", sender: nil)
        
    }
    
    func handleLogin(success: Bool, error: Error?){
        
        if success{
            performSegue(withIdentifier: "completeLogout", sender: nil)
        } else {
            performSegue(withIdentifier: "completeLogout", sender: nil)
            print(error!)
        }
    }
}
