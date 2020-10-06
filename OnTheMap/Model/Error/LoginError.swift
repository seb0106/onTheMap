//*
// * Copyright (C) Schweizerische Bundesbahnen SBB, 2020.
//*

import Foundation
struct LoginError: Decodable{
    let status: Int
    let error: String
}
