//*
// * Copyright (C) Schweizerische Bundesbahnen SBB, 2020.
//*

import Foundation
struct LoginResponse: Codable{
    let account: ConfirmationResponse
    let session: SessionResponse
}

struct ConfirmationResponse: Codable{
    let registered: Bool
    let key: String
}

struct SessionResponse: Codable{
    let id: String
    let expiration: String
}
