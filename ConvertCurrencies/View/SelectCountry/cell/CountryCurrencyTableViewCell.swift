//
//  CountryCurrencyTableViewCell.swift
//  ConvertCurrencies
//
//  Created by Anthony Montes Larios on 26/02/21.
//

import UIKit

class CountryCurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var nameCountryLabel: UILabel!
    @IBOutlet weak var costCurrencyLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
        
    func setupViews(){
        nameCountryLabel.textColor = StyleApp.Color.APP_Black
        nameCountryLabel.font = UIFont(name:"HelveticaNeue-Medium", size: 14.0)
        costCurrencyLabel.textColor = StyleApp.Color.APP_Grey_2
        costCurrencyLabel.font = UIFont(name:"HelveticaNeue-Medium", size: 14.0)
    }
        
    func setData(currency: Currency){
        flagImageView.image = UIImage(named: currency.imageName)
        nameCountryLabel.text =  currency.name
        costCurrencyLabel.text = currency.price
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
