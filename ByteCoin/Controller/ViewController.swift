//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    private var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.coinManager.delegate = self
        self.currencyPicker.delegate = self
    }
}

extension ViewController: CoinManagerDelegate {
    func coinManagerDidReceiveExchangeRate(_ coinManager: CoinManager, rate: CoinExchangeRate) {
        DispatchQueue.main.async {
            print(rate)
            self.currentValueLabel.text = String(format: "%0.3f", rate.rate)
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

extension ViewController: UIPickerViewDataSource {
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

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Update the label value
        let selected = pickerView.selectedRow(inComponent: 0)
        let code = self.coinManager.currencyArray[selected]
        self.coinManager.getExchangeRate(code)
    }
}
