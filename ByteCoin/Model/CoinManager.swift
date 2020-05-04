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
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    let apiKey = "883567E3-76FE-443F-96BF-B007E92CD153"
    
    let currencyArray = ["AUD", "BRL", "CAD", "CNY", "EUR", "GBP", "HKD", "IDR", "ILS", "INR", "JPY", "MXN", "NOK", "NZD", "PLN", "RON", "RUB", "SEK", "SGD", "USD", "ZAR"]

    func getExchangeRate(_ currencyCode: String, usingBitCoin: Bool) {
        var urlString = baseURL
        urlString.append(usingBitCoin ? "BTC/" : "ETH/")
        urlString.append(contentsOf: currencyCode)
        self.attemptFetch(url: URL(string: urlString)!)
    }
    
    private func attemptFetch(url: URL) {
        var request = URLRequest.init(url: url)
        request.addValue(self.apiKey, forHTTPHeaderField: "X-CoinAPI-Key")
        
        let session = URLSession.init(configuration: .default)
        let task = session.dataTask(with: request, completionHandler: { result, response, error in
            if (error != nil) {
                self.delegate?.coinManagerDidFailWithError(self, error: error!)
                return
            }
            
            guard let data = result else {
                return
            }
            
            if let coinData = self.parseJSON(data: data) {
                self.delegate?.coinManagerDidReceiveExchangeRate(self, rate: coinData)
            }
        })
        task.resume()
    }
    
    private func parseJSON(data: Data) -> CoinExchangeRate? {
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(CoinExchangeRate.self, from: data)
            return decoded
        } catch {
            self.delegate?.coinManagerDidFailWithError(self, error: error)
            return nil
        }
    }
}

protocol CoinManagerDelegate {
    func coinManagerDidReceiveExchangeRate(_ coinManager: CoinManager, rate: CoinExchangeRate)
    func coinManagerDidFailWithError(_ coinManager: CoinManager, error: Error)
}
