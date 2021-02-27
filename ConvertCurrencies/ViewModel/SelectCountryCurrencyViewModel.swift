//
//  SelectCountryCurrencyViewModel.swift
//  ConvertCurrencies
//
//  Created by Anthony Montes Larios on 26/02/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol SelectCountryViewModelDelegate : class {
    func selectedCurrency(Currency: Currency)
}

class SelectCountryCurrencyViewModel{
    
    let items = PublishSubject<[Currency]>()
    weak var delegate: SelectCountryViewModelDelegate?
    var CurrencyArray: [Currency] = []
    
    func fetchCurrencyList(){
        //MARK: Call to JSON File
        let url = Bundle.main.url(forResource: "currency", withExtension: "json")                
        guard let jsonData = url else{return}
        guard let data = try? Data(contentsOf: jsonData) else { return }
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode([Currency].self, from: data) {
            CurrencyArray =  jsonPetitions
        }
        //MARK: -Add RXSwift - PublishSubject
        items.onNext(CurrencyArray)
        items.onCompleted()
        
    }
    
    public func selectedCurrency(Currency: Currency) -> Currency{
        return Currency
    }
    
}
