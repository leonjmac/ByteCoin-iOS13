//
//  CoinExchangeRate.swift
//  ByteCoin
//
//  Created by Leon J McLeggan on 04/05/2020.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import Foundation

struct CoinExchangeRate: Codable {
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
}
