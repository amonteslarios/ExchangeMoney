//
//  ConvertCurrencyViewModel.swift
//  ConvertCurrencies
//
//  Created by Anthony Montes Larios on 26/02/21.
//

import Foundation
import RxSwift
import RxCocoa

class ConvertCurrencyViewModel{

    //MARK: - Class Properties
    let getTextPublishSubject = PublishSubject<String>()
    let setTextPublishSubject = PublishSubject<String>()
    
    //MARK: ViewDelegate
    var view:ConvertCurrencyView?
    private var currencyOne : Currency?
    private var currencyTwo : Currency?
    private var getAmount : String?
    var CurrencyArray: [Currency] = []
    let firstPosition = 0
    let secondPosition = 1
    
    //MARK: Property RXSwift
    private let bag = DisposeBag()
    
    init() {
        //Metodo para llamar a Json
        //No se almacena la data en una base datos debido a que el aplication mostraria información en tiempo real
         let url = Bundle.main.url(forResource: "currency", withExtension: "json")
                 
         guard let jsonData = url else{return}
         guard let data = try? Data(contentsOf: jsonData) else { return }
         let decoder = JSONDecoder()

         if let jsonPetitions = try? decoder.decode([Currency].self, from: data) {
             CurrencyArray =  jsonPetitions
         }
        
        currencyOne = CurrencyArray[firstPosition]
        currencyTwo = CurrencyArray[secondPosition]
        
        getTextPublishSubject.asObservable().subscribe(onNext: { string in
        }).disposed(by: bag)
        
        setTextPublishSubject.asObservable().subscribe(
            onNext: { string in
                let setValue = Double(string) ?? 0
                self.getAmount = string
                let result = setValue * (self.currencyOne?.rates.filter{ $0.codeRates == self.currencyTwo?.code}.first!.priceCurrency)!
                self.view?.ResultExchange(result: String(format: "%.2f", result))
                self.buySellMessage(curerncy: (self.currencyOne?.rates.filter{ $0.codeRates == self.currencyTwo?.code}.first)!)
                //Se hace uso del storage del dispositivo para almacenar la ultimos datos de entrada ingresados
                UserDefaults.standard.set(string == "" ? "0" : string, forKey: "getAmount")
            },onCompleted: {
                
         }).disposed(by: bag)
    }
    
    public func changeCurrency(){
        
        let currencySelectOne = currencyOne
        let currencySelectTwo = currencyTwo
        
        view?.ChangeExchange(currencySet: currencyOne!, CurrencyGet: currencyTwo!)        
        currencyOne = currencySelectTwo
        currencyTwo = currencySelectOne
        let setValue = Double(self.getAmount ?? "0") ?? 0
        let result = setValue * (self.currencyOne?.rates.filter{ $0.codeRates == self.currencyTwo?.code}.first!.priceCurrency)!
        self.view?.ResultExchange(result: String(format: "%.2f", result))
        buySellMessage(curerncy: (self.currencyOne?.rates.filter{ $0.codeRates == self.currencyTwo?.code}.first)!)
    }
    
    
    public func exchangeMoney(Currency : Currency, position: Int){
        
        if position == 0{
            currencyOne = Currency
        }else{
            currencyTwo = Currency
        }
        
        let setValue = Double(self.getAmount ?? "0") ?? 0
        let result = setValue * (self.currencyOne?.rates.filter{ $0.codeRates == self.currencyTwo?.code}.first!.priceCurrency)!
        self.view?.ResultExchange(result: String(format: "%.2f", result))

        buySellMessage(curerncy: (self.currencyOne?.rates.filter{ $0.codeRates == self.currencyTwo?.code}.first)!)
    }
    
    func buySellMessage(curerncy: Rate){
        let buySellLabel = "Compra:  \(curerncy.sellPriceMoney)   |   Venta:  \(curerncy.buyPriceMoney)"
        self.view?.updateBuySell(buySell: buySellLabel)
    }
    
}

