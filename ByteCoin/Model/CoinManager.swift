//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "883567E3-76FE-443F-96BF-B007E92CD153"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getExchangeRate(_ currencyCode: String) {
        var urlString = baseURL
        urlString.append(contentsOf: currencyCode)
        self.attemptFetch(url: URL(string: urlString)!)
    }
    
    private func attemptFetch(url: URL) {
        var request = URLRequest.init(url: url)
        request.addValue(self.apiKey, forHTTPHeaderField: "X-CoinAPI-Key")
        
        let session = URLSession.init(configuration: .default)
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if (error != nil) {
                self.delegate?.coinManagerDidFailWithError(self, error: error!)
                return
            }
            
            let decoder = JSONDecoder()
            let parsedData = try! decoder.decode(CoinExchangeRate.self, from: data!)
            self.delegate?.coinManagerDidReceiveExchangeRate(self, rate: parsedData)
        })

        task.resume()
    }
}

protocol CoinManagerDelegate {
    func coinManagerDidReceiveExchangeRate(_ coinManager: CoinManager, rate: CoinExchangeRate)
    func coinManagerDidFailWithError(_ coinManager: CoinManager, error: Error)
}
