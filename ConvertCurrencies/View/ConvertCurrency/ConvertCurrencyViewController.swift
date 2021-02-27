//
//  ConvertCurrencyViewController.swift
//  ConvertCurrencies
//
//  Created by Anthony Montes Larios on 26/02/21.
//

import UIKit
import RxSwift
import RxCocoa

protocol ConvertCurrencyView{
    func ResultExchange(result: String)
    func SetExchange(result: String)
    func ChangeExchange(currencySet: Currency,CurrencyGet: Currency)
    func setStorageData(setData: String, result: String)
    func updateBuySell(buySell : String)
}

class ConvertCurrencyViewController: UIViewController, ConvertCurrencyView {

    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var changesButton: UIButton!
    @IBOutlet weak var setInputTextfield: UITextField!
    @IBOutlet weak var getInputTextfield: UITextField!
    @IBOutlet weak var purchaseSaleLabel: UILabel!
    @IBOutlet weak var containerSetView: UIView!
    @IBOutlet weak var containerGetView: UIView!
    
    @IBOutlet weak var setStackView: UIStackView!
    @IBOutlet weak var getStackView: UIStackView!
    @IBOutlet weak var firstCurrencyButton: UIButton!
    @IBOutlet weak var secondCurrencyButton: UIButton!
    @IBOutlet weak var sendLabel: UILabel!
    @IBOutlet weak var getLabel: UILabel!
    
    //MARK: - Parameters
    private let ConvertViewModel = ConvertCurrencyViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Lyfe Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLabels()
        //Para este proyecto se hizo el uso del patron arquitectonico de MVVM - aplicando RXSwift y RXCocoa -  a la vez se esta haciendo el uso de patrones de diseño como el Singelton y Facade
        ConvertViewModel.view = self
        getDataStorage()
        textfieldEvent()
        buttonEvent()
        setupHideKeyboardOnTap(container: view)
    }
    
    func getDataStorage(){
        let getAmountSave =  UserDefaults.standard.string(forKey: "getAmount")
        if getAmountSave != ""  {
            setInputTextfield.text = getAmountSave
        }        
    }
    
    override func viewDidLayoutSubviews() {
       super.viewDidLayoutSubviews()
        changesButton.layer.cornerRadius = changesButton.frame.size.width/2
        changesButton.clipsToBounds = true
    }
    
    
    // MARK: - Setup
    private func setupViews() {
        containerView.layer.cornerRadius = 10.0
        containerView.layer.borderWidth = 2.0
        containerView.layer.borderColor = StyleApp.Color.APP_Grey.cgColor
        
        let border = CALayer()
        border.backgroundColor = StyleApp.Color.APP_Grey.cgColor
        border.frame = CGRect(x: 0, y: setStackView.frame.size.height - 2, width: setStackView.frame.size.width, height: 2)
        setStackView.layer.addSublayer(border)
    }
    
    private func setupLabels(){
        sendLabel.textColor = .gray
        sendLabel.font = UIFont(name:"HelveticaNeue-Medium", size: 10.0)
        getLabel.textColor = .gray
        getLabel.font = UIFont(name:"HelveticaNeue-Medium", size: 10.0)
    }
    
    // MARK: - Additional Methods
    func textfieldEvent(){
        getInputTextfield.rx.text.map { $0 ?? "1"}.bind(to: ConvertViewModel.getTextPublishSubject).disposed(by:disposeBag)
        setInputTextfield.rx.text.map { $0 ?? "1"}.bind(to: ConvertViewModel.setTextPublishSubject).disposed(by:disposeBag)
    }
    
    func buttonEvent(){
        let firstlongGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        //Según el requerimiento comentado la función se llamara cuando el usuario mantenga presionado la opción de moneda
        firstlongGesture.minimumPressDuration = 0.5
        firstlongGesture.delaysTouchesBegan = true

        let secondelongGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        //Según el requerimiento comentado la función se llamara cuando el usuario mantenga presionado la opción de moneda
        secondelongGesture.minimumPressDuration = 0.5
        secondelongGesture.delaysTouchesBegan = true

        
        firstCurrencyButton.addGestureRecognizer(firstlongGesture)
        secondCurrencyButton.addGestureRecognizer(secondelongGesture)
    }
    
    func setStorageData(setData: String, result: String) {
        setInputTextfield.text = setData
        getInputTextfield.text = result
    }
    
    func ResultExchange(result: String) {
        getInputTextfield.text = result
    }
    
    func SetExchange(result: String){
        setInputTextfield.text = result
    }
    
    func ChangeExchange(currencySet: Currency,CurrencyGet: Currency){
        firstCurrencyButton.setTitle(CurrencyGet.nameMoney, for: .normal)
        secondCurrencyButton.setTitle(currencySet.nameMoney, for: .normal)
    }
    
    func updateBuySell(buySell : String){
        purchaseSaleLabel.text = buySell
    }

    // MARK: - IBActions
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        //Se valida el estado del gesto para solo usarlo cuando se este iniciando
        guard let button = sender.view as? UIButton else { return }
        if sender.state == .began{
            print("Long press")
            performSegue(withIdentifier: "segueSelectCurrency", sender: button.tag)
        }
    }
    
    @IBAction func changesExchangeButtonAction(_ sender: Any) {             
        //Añadiendo animación para que se pueda ver el cambio de moneda dentro de la vista
        UIView.animate(withDuration: 0.5) {
            self.changesButton.transform = self.changesButton.transform.rotated(by: CGFloat.pi)
            self.ConvertViewModel.changeCurrency()
            self.changesButton.transform = self.changesButton.transform.rotated(by: CGFloat.pi)
        }
        
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Uso de prepare para poder enviar el tag del boton para saber que boton se selecciono
        if segue.identifier == "segueSelectCurrency"{
            let detailVC = segue.destination as! SelectCountryCurrencyViewController
            detailVC.selectOption = sender as! Int
            detailVC.delegate = self
        }
    }

}

extension ConvertCurrencyViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let arrayOfString = newString.components(separatedBy: ".")

        if arrayOfString.count > 2 {
            return false
        }
        return true
    }
    
}

extension ConvertCurrencyViewController: SelectCountryCurrencyDelegate{
    
    func selectedCurrency(Currency: Currency, Option: Int) {
        //Se llama a evento a traves de un delegado para poder obtener la información de celda seleccionada y enviar a ViewModel
        ConvertViewModel.exchangeMoney(Currency: Currency, position: Option)
        if Option == 0{
            firstCurrencyButton.setTitle(Currency.nameMoney, for: .normal)
        }else{
            secondCurrencyButton.setTitle(Currency.nameMoney, for: .normal)
        }
                        
    }
}
