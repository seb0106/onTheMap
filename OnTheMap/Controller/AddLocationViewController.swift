//*
// * Copyright (C) Schweizerische Bundesbahnen SBB, 2020.
//*

import Foundation
import UIKit

class AddLocationViewController: UIViewController {
    @IBOutlet weak var linkedInURLTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MapLocationViewController {
            let vc = segue.destination as? MapLocationViewController
            vc?.geocode = locationTextField.text
            vc?.mediaLink = linkedInURLTextField.text
        }
    }
}
