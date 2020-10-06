//*
// * Copyright (C) Schweizerische Bundesbahnen SBB, 2020.
//*

import Foundation
struct LoginRequest: Codable {
    
    let udacity: UserInformationRequest
    
    enum CodingKeys: String, CodingKey {
        case udacity
    }
}
