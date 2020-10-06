//*
// * Copyright (C) Schweizerische Bundesbahnen SBB, 2020.
//*

import Foundation

struct StudentLocationRequest: Codable{
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    
}
