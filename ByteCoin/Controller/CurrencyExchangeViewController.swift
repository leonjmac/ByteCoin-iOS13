//
//  CurrencyExchangeViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class CurrencyExchangeViewController: UIViewController {
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var currencyIcon: UIImageView!
    
    private var convertBitCoin = true
    private var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.coinManager.delegate = self
        self.currencyPicker.delegate = self
    }
    
    @IBAction func toggleCoinType(_ sender: UIButton) {
        self.convertBitCoin.toggle()
        self.getExchangeRate()
        let imageName = self.convertBitCoin ? "bitcoinsign.circle.fill" : "eurosign.circle.fill"
        self.currencyIcon.image = UIImage(systemName: imageName)
        
    }
    
    private func getExchangeRate() {
        let selected = currencyPicker.selectedRow(inComponent: 0)
        let code = self.coinManager.currencyArray[selected]
        self.coinManager.getExchangeRate(code, usingBitCoin: convertBitCoin)
    }
}

extension CurrencyExchangeViewController: CoinManagerDelegate {
    func coinManagerDidReceiveExchangeRate(_ coinManager: CoinManager, rate: CoinExchangeRate) {
        DispatchQueue.main.async {
            let formattedText = NumberFormatter.localizedString(from: NSNumber(value: rate.rate), number: .decimal)
            self.currentValueLabel.text = formattedText
            self.currencyLabel.text = rate.asset_id_quote
        }
    }
    
    func coinManagerDidFailWithError(_ coinManager: CoinManager, error: Error) {
        // present alert to user advising of error
        DispatchQueue.main.async {
            let alert = UIAlertController.init(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension CurrencyExchangeViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.coinManager.currencyArray[row]
    }
}

extension CurrencyExchangeViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Update the label value
        self.getExchangeRate()
    }
}
