//
//  currency.swift
//  ConvertCurrencies
//
//  Created by Anthony Montes Larios on 26/02/21.
//

import Foundation



struct Currency: Codable {
    let code, imageName, name, price, nameMoney : String
    let rates: [Rate]
}

// MARK: - Rate
struct Rate: Codable {
    let codeRates: String
    let priceCurrency: Double
    let sellPriceMoney, buyPriceMoney : String    
}


