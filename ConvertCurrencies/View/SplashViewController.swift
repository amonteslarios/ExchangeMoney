//
//  SplashViewController.swift
//  ConvertCurrencies
//
//  Created by Anthony Montes Larios on 26/02/21.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var containerAnimationView: UIView!
    //MARK: - Parameters
    private var animationView: AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Se añade lottie para poder dar una animación al loading de la pantalla splashview - 
        animationView = .init(name: "loading")
        animationView!.frame = containerAnimationView.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.5
        containerAnimationView.addSubview(animationView!)
        //Se reproduce el lottie Json
        animationView!.play()
        
        //Se añade un delay de 3 segundos para poder visualizar la carga de la aplicación
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            //Se llama al controller Core mediante presenter
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ConvertCurrencyViewController") as! ConvertCurrencyViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: {
                //Se para la animación ya que no queremos que este haciendo uso de un pequeño espacio de memoria
                self.animationView?.stop()
            })
        }
        
    }
    
}
