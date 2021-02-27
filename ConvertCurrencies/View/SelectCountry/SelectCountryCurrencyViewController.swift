//
//  SelectCountryCurrencyViewController.swift
//  ConvertCurrencies
//
//  Created by Anthony Montes Larios on 26/02/21.
//

import UIKit
import RxSwift
import RxCocoa

protocol SelectCountryCurrencyDelegate {
    func selectedCurrency(Currency: Currency, Option: Int)
}

class SelectCountryCurrencyViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var countryTableView: UITableView!
    
    //MARK: - Parameters
    public let CountryViewModel = SelectCountryCurrencyViewModel()
    private let disposeBag = DisposeBag()
    var selectOption : Int = 0
    var heightCell : CGFloat =  70
    var delegate : SelectCountryCurrencyDelegate?
    private let countryCurrencyCell = "CountryCurrencyTableViewCell"
    private let countryCellId = "countryCellId"
    
    // MARK: - Lyfe Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        CountryViewModel.delegate = self
        setupViews()
    }

    // MARK: - Setup
    private func setupViews() {
        //MARK:RXSwift Methods
        //Uso de RxSwift y RxCocoa para el uso de la tabla ya sea agregando el delagado como haciendo un registro para añadir la celda creada.
        //Se uso un Xib  en la celda, para facilitar el mantenimiento de la vista
        countryTableView.rx.setDelegate(self).disposed(by: disposeBag)
        countryTableView.bounces = false
        countryTableView.register(UINib(nibName: countryCurrencyCell, bundle: nil), forCellReuseIdentifier: countryCellId)

        CountryViewModel.items.bind(to: countryTableView.rx.items(cellIdentifier: countryCellId, cellType: CountryCurrencyTableViewCell.self)) { (row,item,cell) in
            cell.setData(currency: item)
        }.disposed(by: disposeBag)
        
        countryTableView.rx.modelSelected(Currency.self).subscribe(onNext: { [self] item in
            //Seleccion de la celda
            dismiss(animated: true) {
                delegate?.selectedCurrency(Currency: item, Option: selectOption)
            }
        }).disposed(by: disposeBag)
        CountryViewModel.fetchCurrencyList()                
    }
    
}

extension SelectCountryCurrencyViewController : SelectCountryViewModelDelegate{
    func selectedCurrency(Currency: Currency) {
        
    }
        
}

extension SelectCountryCurrencyViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightCell
    }
    
}
